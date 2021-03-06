import numpy as np
import sys, os
import pprint
import time
from math import *
pp = pprint.PrettyPrinter(indent=2)
import multiprocessing as mp

parentPath = os.path.abspath("../GRASP")
if parentPath not in sys.path:
    sys.path.insert(0, parentPath)
from Common.NurseSchedulingProblem import *
from Greedy import isFeasible


def checkIfCanWork(solution, h, n, data, sumW, hini=None):
    minHours = data["minHours"]
    hours = data["hours"]
    z = solution["z"]
    w = solution["w"]

    #print(z[n])
    #if z[n]==0:
    #    print("nurse " + str(n) + " check can work at " + str(h) + " cause hini =" + str(hini[n]) + " z[n]" + str(z[n]) + " can work?:"+ str(hini[n] < h and z[n]==0))
        
    if hini:
        if hini[n] < h and z[n]==0:
            #print("nurse " + str(n) + "cannot work at " + str(h) + " cause hini =" + str(hini[n]))
            return False

    aux = w[n][h]
    w[n][h] = 1

    # minHours validity
    verify_minHours = False
    if z[n] == 1 and hours - h + 1 < minHours - sumW[n]:
        verify_minHours=True

    # verify max rest constraint if not working
    rest_check, maxPresence_check, maxConsec_check, maxHours_check, minHours_check = complete_schedule_validation(solution, data, n, verify_minHours=verify_minHours, whattoreturn='All')

    # undo changes, just a verification
    w[n][h] = aux

    if rest_check and \
        maxPresence_check and \
        maxConsec_check and  \
        maxHours_check and \
        minHours_check:


        return True

    return False


def checkIfMustWork(solution, h, n, data, sumW, canWork_check, hini=None):
    minHours = data["minHours"]
    hours = data["hours"]
    z = solution["z"]
    w = solution["w"]
    aux = w[n][h]

    w[n][h] = 0

    # minHours validity
    verify_minHours = False
    if z[n] == 1 and hours - h + 1 < minHours - sumW[n]:
        verify_minHours = True

    # verify max rest constraint if not working
    rest_check, maxPresence_check, maxConsec_check, maxHours_check, minHours_check = incremental_schedule_validation(solution, data, n, verify_minHours=verify_minHours, whattoreturn='All', force_rest_check=False, set_end=h)

    # undo changes, just a verification
    w[n][h] = aux

    # print("CanRest w[" + str(n) + "][" + str(h) + "] = " + str(w[n][h]) + " ?:")
    # # print(rest_check)
    # print("rest_checkt " + str(rest_check))
    # print("minHours_checkt " + str(minHours_check))
    # print("maxHours_checkt " + str(maxHours_check))
    # print("maxConsec_checkt " + str(maxConsec_check))
    # print("maxPresence_checkt " + str(maxPresence_check))

    if ((not rest_check and minHours_check) or \
        (not rest_check and not minHours_check) or \
        (rest_check and not minHours_check)) and \
       maxPresence_check and \
       maxConsec_check and  \
       maxHours_check :

        # cannot rest!, verify if can work:
        # should always be true at the same time!
        if not canWork_check:
            print(" INCOHERENCE DETECTED cannot rest but cannot work!")

        return canWork_check

    return False



def computeAssignments_mp_aux(solution, h, n, data, sumW, hini):

    # canWork Check-------------------------------
    mustWork_check = False
    canWork_check = checkIfCanWork(solution, h, n, data, sumW, hini)
    if canWork_check:
       
        # mustWork Check-------------------------------
        # avoid repeating canWork_check
        mustWork_check = checkIfMustWork(solution, h, n, data, sumW, canWork_check, hini)

    return (mustWork_check, canWork_check)

def computeAssignments_mp(solution, h, data, sumW, hini=None):
    """
        for each nurse,
            if hini != None and h>hini[n] and z[n]==0 -> that nurse cannot work
            compute which nurses must work at time h to be valid
            compute which nurses can work at time h and still be valid

    """
    minHours = data["minHours"]
    hours = data["hours"]
    z = solution["z"]
    w = solution["w"]

    mustWork = []
    canWork = []

    # sort nurses, first by those who work
    sorted_nurses = sorted(range(data["nNurses"]), key=lambda n: solution["z"][n], reverse=True)
    # print(solution["z"])
    # print(sorted_nurses)
    # print("")

    pool = mp.Pool(processes=mp.cpu_count())
    mustWork_canWork = [pool.apply(computeAssignments_mp_aux, args=(solution, h, n, data, sumW, hini)) for n in sorted_nurses] 

    return mustWork_canWork



def assignNurses_mp(solution, hini, data):

    """
        hini is used to add extra nurses at each hour
            hini[h]=0.2 -> means we add 0.1*demand[h] in terms of nurse assigments

    """

    demand = data["demand"]
    pending = solution["pending"]
    hours = data["hours"]
    sumW = [0] * data["nNurses"]

    z = solution["z"]
    w = solution["w"]

    for h in range(hours):

        # for each hour

        # compute valid candidates
        #  those who must be assigned (rest constraint)
        #  those who can be assigned to work
        #  if h>hini and z[n]== 0 , that nurse cannot work
        mustWork_canWork = computeAssignments_mp(solution, h, data, sumW)

        # print("h=" + str(h))
        # print("mustWork")
        # print(mustWork)
        # print("canWork")
        # print(canWork)
        # print("hini:")
        # print(hini)
        # print("demand")
        # print(data["demand"])
        # print("pending")
        # print(solution["pending"])

  
        #   try to assign if pending[h] > 0 and h >= hini[n]
        for n in range(len(mustWork_canWork)):
            if mustWork_canWork[n][0]:
                # print("nurse :" + str(n) + "  h: " + str(h) + " pending: ")
                # print(pending)
                w[n][h] = 1
                sumW[n] += 1
                pending[h] -= 1
                if z[n] == 0:
                    z[n] = 1
                    solution["cost"] += 1
                #print("w[" + str(n) + "," + str(h) + "] = 1")
                # pp.pprint(solution["w"])



        for n in range(len(mustWork_canWork)):
            if not mustWork_canWork[n][0] and mustWork_canWork[n][1]:
                # print("nurse :" + str(n) + "  h: " + str(h) + " pending: ")
                # print(pending)
                if pending[h] + hini[h] > 0:    
                    w[n][h] = 1
                    sumW[n] += 1
                    pending[h] -= 1
                    if z[n] == 0:
                        z[n] = 1
                        solution["cost"] += 1
                    #print("w[" + str(n) + "," + str(h) + "] = 1")
                # print("w[" + str(n) + "]")
                # pp.pprint(solution["w"])

    # pp.pprint(data)
    # pp.pprint(solution["cost"])
    # exit()


    # compute feasibility: if unfeasible -> fitness should be inf
    if not isFeasible(solution, data):
        # assign the max cost
        solution["cost"] = 200000 * data["nNurses"]


def computeAssignments(solution, h, data, sumW, hini=None):
    """
        for each nurse,
            if hini != None and h>hini[n] and z[n]==0 -> that nurse cannot work
            compute which nurses must work at time h to be valid
            compute which nurses can work at time h and still be valid

    """
    minHours = data["minHours"]
    hours = data["hours"]
    z = solution["z"]
    w = solution["w"]

    mustWork = []
    canWork = []

    # sort nurses, first by those who work
    sorted_nurses = sorted(range(data["nNurses"]), key=lambda n: solution["z"][n], reverse=True)
    # print(solution["z"])
    # print(sorted_nurses)
    # print("")

    # for each nurse
    for n in sorted_nurses:


        # canWork Check-------------------------------
        canWork_check = checkIfCanWork(solution, h, n, data, sumW, hini)
        if canWork_check:
           
            # mustWork Check-------------------------------
            # avoid repeating canWork_check
            mustWork_check = checkIfMustWork(solution, h, n, data, sumW, canWork_check, hini)
            if mustWork_check:
                mustWork.append(n)
            else:
                canWork.append(n)


    return mustWork, canWork



def assignNurses(solution, hini, data):

    """
        hini is used to add extra nurses at each hour
            hini[h]=0.2 -> means we add 0.1*demand[h] in terms of nurse assigments

    """

    demand = data["demand"]
    pending = solution["pending"]
    hours = data["hours"]
    sumW = [0] * data["nNurses"]

    z = solution["z"]
    w = solution["w"]

    for h in range(hours):

        # for each hour

        # compute valid candidates
        #  those who must be assigned (rest constraint)
        #  those who can be assigned to work
        #  if h>hini and z[n]== 0 , that nurse cannot work
        mustWork, canWork = computeAssignments(solution, h, data, sumW)

        # print("h=" + str(h))
        # print("mustWork")
        # print(mustWork)
        # print("canWork")
        # print(canWork)
        # print("hini:")
        # print(hini)
        # print("demand")
        # print(data["demand"])
        # print("pending")
        # print(solution["pending"])

  
        #   try to assign if pending[h] > 0 and h >= hini[n]
        for n in mustWork:
            # print("nurse :" + str(n) + "  h: " + str(h) + " pending: ")
            # print(pending)
            w[n][h] = 1
            sumW[n] += 1
            pending[h] -= 1
            if z[n] == 0:
                z[n] = 1
                solution["cost"] += 1
            #print("w[" + str(n) + "," + str(h) + "] = 1")
            # pp.pprint(solution["w"])



        for n in canWork:
            # print("nurse :" + str(n) + "  h: " + str(h) + " pending: ")
            # print(pending)
            if pending[h] + hini[h] > 0:    
                w[n][h] = 1
                sumW[n] += 1
                pending[h] -= 1
                if z[n] == 0:
                    z[n] = 1
                    solution["cost"] += 1
                #print("w[" + str(n) + "," + str(h) + "] = 1")
            # print("w[" + str(n) + "]")
            # pp.pprint(solution["w"])

    # pp.pprint(data)
    # pp.pprint(solution["cost"])
    # exit()


    # compute feasibility: if unfeasible -> fitness should be inf
    if not isFeasible(solution, data):
        # assign the max cost
        solution["cost"] = 200000 * data["nNurses"]


def decode_hexcess_mp_aux(ind, n):
    # option 2f
    hi = 0
    if ind < 0.2:
        therange = ceil(0.8 * n)
        hi = int(therange * ind)

    return hi


def decode_hexcess_mp(ind, data):

    print(len(ind["chr"]))
    pool = mp.Pool(processes=1)
    hini = [pool.apply(decode_hexcess_mp_aux, args=(ind['chr'][i], data["nNurses"])) for i in range((len(ind['chr'])) )  ]

    return hini


def decode_hexcess(ind, data):
    hini = []

    for i in range(len(ind['chr'])):
        # option 2
        therange = data["demand"][i]
        # option 2b
        # therange = 10
        # option 2c
        # therange = 1
        # option 2d
        # therange = ceil(0.1*data["nNurses"])
        # option 2e
        # therange = ceil(0.3*data["nNurses"])

        #hi = int(therange * ind['chr'][i])
        
        # option 2f
        hi = 0
        if ind['chr'][i] < 0.2:
            therange = ceil(0.8 * data["nNurses"])
            hi = int(therange * ind['chr'][i])

        hini.append(hi)

    return hini


def diversity(population):

    s = set([x['fitness'] for x in population])
    return len(s)


def decode_normal(population, data):
    """
        # diversify by excees of assignments per hour

    """

    for ind in population:

        #  decode_hexcess 65.8s
        hini = decode_hexcess(ind, data)
        # decode_hexcess_mp 
        # hini = decode_hexcess_mp(ind, data)


        # 2) assign work hours to nurses
        solution = {
            "cost": 0,
            "w": [[0] * data["hours"] for n in range(data["nNurses"])],
            "z": [0] * data["nNurses"],
            "last_added": 0,
            "pending": list(data["demand"]),
            "totalw": 0,
            "exceeding": [0] * data["hours"]
        }

        assignNurses(solution, hini, data)
        #assignNurses_mp(solution, hini, data)

        ind['solution'] = solution

        ind['fitness'] = solution["cost"]

    print("breed: " + str(len(population)) + " individuals")
    print("diversity: " + str(diversity(population)))
    return(population)


def decode_mp_aux(population, data, ind):

    hini = decode_hexcess(ind, data)

    solution = {
        "cost": 0,
        "w": [[0] * data["hours"] for n in range(data["nNurses"])],
        "z": [0] * data["nNurses"],
        "last_added": 0,
        "pending": list(data["demand"]),
        "totalw": 0,
        "exceeding": [0] * data["hours"]
    }

    assignNurses(solution, hini, data)

    ind['solution'] = solution

    ind['fitness'] = solution["cost"]

    return ind

def decode_mp(population, data):
    """
        # diversify by excees of assignments per hour

        decode_normal with 0035-i-ng   -> 64.81s
        decode_mp     with 0035-i-ng   -> 135.69 

        0619-i-ng    decode_mp -> 
        0619-i-ng    decode_normal ->
    """
    pool = mp.Pool(processes=mp.cpu_count())
    population_w_cost = [pool.apply(decode_mp_aux,
                          args=(population, data, ind))
               for ind in population]
    print("breed: " + str(len(population_w_cost)) + " individuals")
    print("diversity: " + str(diversity(population_w_cost)))
    return(population_w_cost)


def decode(population, data):

    return decode_normal(population, data)
    #return decode_mp(population, data)

def getChrLength(data):
    return int(data["hours"])



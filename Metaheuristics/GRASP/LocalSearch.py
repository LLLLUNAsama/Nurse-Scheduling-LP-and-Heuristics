# -*- coding: utf-8 -*-
"""
@author: Adrian Rodrigez Bazaga, Pau Rodriguez Esmerats
"""

import pprint
import os, sys

parentPath = os.path.abspath(".")
if parentPath not in sys.path:
    sys.path.insert(0, parentPath)

pp = pprint.PrettyPrinter(indent=2)

from Greedy import *


printlog = False
printlog_mainloop = False
printlog_createNeighborhood = False
printlog_electiveCandidates = False
printlog_findCandidates = False
printlog_validity = False

def copySol(solution, data):

    copied_sol = {
        "cost": data["nNurses"],
        "w": deepcopy(solution["w"]),
        "z": list(solution["z"]),
        "last_added": 0,
        "pending": list(solution["pending"]),
        "totalw": solution["totalw"],
        "exceeding": list(solution["exceeding"])
    }

    return copied_sol


def exceedingCapacityRemoval(candidate, n, data):
    """
        Given a solution(candidate) and a nurse
        this function removes any assignment w[n][h] whenever
        capacity is exceeded at some hour h and
        the resulting schedule is valid
    """

    for h in range(data["hours"]):
        if candidate["w"][n][h] == 1 and candidate["exceeding"][h] > 0:
            candidate["w"][n][h] = 0

            # validate
            if complete_solution_validation(data, candidate):
                if printlog or printlog_electiveCandidates:
                    print("-->valid elimination!  n" + str(n) + " h:" + str(h))
                    pp.pprint(candidate)
                    print()

                candidate["exceeding"][h] -= 1
            else:
                candidate["w"][n][h] = 1


def buildNewSol(neighbor, data):
    """
        given a recently build solution (neighbor)
        this function computes:
            the cost,
            the exceeding capacity,
            the pending assignments
            the total assigned hours
    """

    totalw = 0
    sumz = 0
    columnarSum = [-1 * d for d in data["demand"]]
    columnarPending = list(data["demand"])

    for n in range(len(neighbor["w"])):

        sumZn = 0
        for h in range(len(neighbor["w"][n])):
            totalw += neighbor["w"][n][h]
            sumZn += neighbor["w"][n][h]
            # pending and exceeding
            columnarSum[h] += neighbor["w"][n][h]
            columnarPending[h] -= neighbor["w"][n][h]
            columnarPending[h] = max(columnarPending[h], 0)

        if sumZn > 0:
            neighbor["z"][n] = 1
            sumz += 1
        else:
            neighbor["z"][n] = 0

    neighbor["pending"] = columnarPending
    neighbor["exceeding"] = columnarSum
    neighbor["cost"] = sumz
    neighbor["totalw"] = totalw

    return neighbor


def electiveCandidate(candidate, n, h, data):

    # first try to remove candidate assign if exceeding capcity
    if candidate["exceeding"][h] > 0:
        candidate["w"][n][h] = 0

        # validate
        if complete_solution_validation(data, candidate):
            if printlog or \
               printlog_electiveCandidates or \
               printlog_findCandidates:
                print("-->valid elimination!  n" + str(n) + " h:" + str(h))
                pp.pprint(candidate)
                print()

            # update pending and exceeding
            candidate["exceeding"][h] -= 1

            return candidate
        else:
            # if this removing is not valid, restore state
            candidate["w"][n][h] = 1

    # then try to find a candidate replacement among other nurses
    for ni in (range(data["nNurses"])):

        # save state for nurse ni
        aux_list = list(candidate["w"][ni])
        aux_list2 = list(candidate["exceeding"])

        # remove all exceeding capacity assignmnts for nurse ni
        exceedingCapacityRemoval(candidate, ni, data)

        if ni == n:
            continue
        elif candidate["z"][ni] == 0:
            continue
        elif candidate["w"][ni][h] == 1:
            candidate["w"][ni] = aux_list
            continue
        else:

            if printlog or printlog_electiveCandidates:
                print("exchange " +
                      str(n) + ", " +
                      str(h) + " with " +
                      str(ni) + ", " +
                      str(h))

            candidate["w"][ni][h] = 1
            candidate["w"][n][h] = 0

            if complete_solution_validation(data, candidate):
                if printlog or printlog_electiveCandidates:
                    print("-->valid exchange!")
                    # pp.pprint(candidate)
                    print()

                return candidate

            else:
                # if exchange is not valid, restore state
                candidate["w"][ni] = aux_list
                candidate["w"][n][h] = 1
                candidate["exceeding"] = aux_list2

    # then try to place the hour assignment among nurses that do not work
    for ni in (range(data["nNurses"])):

        # save state for nurse ni
        aux_list = list(candidate["w"][ni])
        aux_list2 = list(candidate["exceeding"])

        # remove all exceeding capacity assignmnts for nurse ni
        exceedingCapacityRemoval(candidate, ni, data)

        if ni == n:
            continue
        elif candidate["z"][ni] == 1:
            continue
        else:

            if printlog or printlog_electiveCandidates:
                print("exchange " +
                      str(n) + ", " +
                      str(h) + " with " +
                      str(ni) + ", " +
                      str(h))

            candidate["w"][ni][h] = 1
            candidate["w"][n][h] = 0

            if complete_solution_validation(data, candidate):
                if printlog or printlog_electiveCandidates:
                    print("-->valid exchange!")
                    # pp.pprint(candidate)
                    print()

                return candidate

            else:
                # if exchange is not valid, restore state
                candidate["w"][ni] = aux_list
                candidate["w"][n][h] = 1
                candidate["exceeding"] = aux_list2

    return candidate


def findCandidate(solution, data, n):
    """ 
         this function returns a new solution that include:
            - 0 hours assigned to nurse n
            - all the hours that where assigned to nurse n
              are assigned to other nurses
            - the solution is valid (constraints)
    """

    # make changes to a copy s
    s = copySol(solution, data)
    for h in range(data["hours"]):

        if printlog or printlog_findCandidates:
            print(" h = " + str(h))
            pp.pprint(s["w"][n])

        if s["w"][n][h] == 1:
            electiveCandidate(s, n, h, data)

    s = buildNewSol(s, data)

    # pp.pprint(s)

    if s["z"][n]==0:
        # the nurse has been freed from work
        # the cost has decreased
        return [s]
    elif s["totalw"] < solution["totalw"]:
        # the cost has not decreased
        # but # assignments is reduced,
        # useful for further improvements
        return[s]
        #return[]
        
    else:
        
        return []


def nursesAtHourH(solution, h):
    """
        this function computes the total nurse assignments
        at hour h
    """
    sumN = 0
    for w in solution["w"]:
        sumN += w[h]
    return sumN


def exceedingNurseHours(solution, data):
    """
    this function computes and stores the
    exceeding capacity for each hour

    """

    solution["exceeding"] = [0] * len(solution["w"][0])
    for h in range(data["hours"]):
        solution["exceeding"][h] = nursesAtHourH(solution, h) - \
            data["demand"][h]

    if printlog or printlog_electiveCandidates:
        print("exceeding capacity")
        print(solution["exceeding"])
        print("")


def firstImprovementLocalSearch(solution, data):
    # first improvement Local search: looks for new sols while improves

    # computes and stores the exceeding capacity
    exceedingNurseHours(solution, data)

    improved = True

    while improved:

        improved = False
        for n in range(0, data["nNurses"], 1):
            if solution["z"][n] == 0:
                continue

            ns = findCandidate(solution, data, n)

            if len(ns) > 0:
                new_sol = ns[0]

                # look for feasibility
                # and for cost[new_solution] < cost[solution]
                if isFeasible(new_sol, data) and new_sol["cost"] < solution["cost"]:
                    solution = new_sol
                    improved = True
                    break
                    
    return solution


def mp_aux(solution, data, n):

    if solution["z"][n] == 0:
        return None

    ns = findCandidate(solution, data, n)

    if len(ns) > 0:
        new_sol = ns[0]

        # look for feasibility
        # and for cost[new_solution] < cost[solution]
        if isFeasible(new_sol, data) and new_sol["cost"] < solution["cost"]:
            return new_sol

    return None
            

def firstImprovementLocalSearch_mp(solution, data):
    # first improvement Local search: looks for new sols while improves

    # computes and stores the exceeding capacity
    exceedingNurseHours(solution, data)

    improved = True

    while improved:

        improved = False

        # launch each n in a difference process,
        # don't wait all to finish
        # as soon as one finishes verify if feasible or if not null
        # as soon as one is not null -> break and start again
        # current benchmark 0035-i-.. -> takes 30~80 seconds this part!
        # with mp           0035-i-.. -> takes 34~25 seconds
        
        pool = mp.Pool(processes= mp.cpu_count())
        results = [pool.apply_async(mp_aux,args=(solution, data, n)) for n in range(data["nNurses"])]
        for p in results:
            new_sol = p.get()
            if new_sol:
                pool.terminate()
                solution = new_sol
                improved = True
                #print(" --> improvement: " + str(solution["cost"]))
                #print("terminating all pool processes")
                break
                    
    return solution



def firstImprovementLocalSearch_intensive(incumbent, maxFailed, data):

    failed_iterations = 0
    while failed_iterations < maxFailed:

        solution2 = firstImprovementLocalSearch_mp(incumbent, data)
        
        if solution2["cost"] >= incumbent["cost"]:
            print("     Searching, Cost=" +
                  str(solution2["cost"]) +
                  " Total_W=" +
                  str(solution2["totalw"]))
            failed_iterations += 1
        else:
            print(" --> Improvement: " + str(solution2["cost"]))
            failed_iterations = 0

        incumbent = solution2

    return incumbent



def createNeighborhood(solution, data):
    """
    creates a set of solutions that are
    neighbors to the current solution

    feasibility is not verified at this point
    (it should be feasible if input solution is feasible)

    each neighbor only changes one nurse!
    """

    Ns = []

    if printlog:
        print("Initial solutioni: " + "-" * 24)
        pp.pprint(solution)
        print()

    # computes and stores the exceeding capacity
    exceedingNurseHours(solution, data)

    for n in range(0, data["nNurses"], 1):
        if solution["z"][n] == 0:
            continue

        if printlog or printlog_createNeighborhood:
            print("")
            print("Nurse " + str(n))

        ns = findCandidate(solution, data, n)

        if printlog or printlog_createNeighborhood:
            print(" after findCandidates " + "--" * 10)
            pp.pprint(ns)
            print("")

        if len(ns) > 0:
            Ns.extend(ns)

    return Ns


def createNeighborhood2(solution, data):
    """
    creates a set of solutions that are
    neighbors to the current solution

    feasibility is not verified at this point
    (it should be feasible if input solution is feasible)

    removes as many nurses as it cans in the same solution. 
    starting point matters here! 
    so calling function should randomize some how the nurse by which
    this function starts
    """

    Ns = []
    

    if printlog:
        print("Initial solutioni: " + "-" * 24)
        pp.pprint(solution)
        print()

    # computes and stores the exceeding capacity
    exceedingNurseHours(solution, data)

    nurse = 0
    while nurse < data["nNurses"]:
    #for nurse in range(0, data["nNurses"], 1):
        last_solution = solution
        zerofound = True

        #print(" point nurse " + str(nurse))
        last_nurse = 0
        for m in range(0, data["nNurses"], 1):
            last_nurse = m
            n = (m + nurse) % data["nNurses"]

            if solution["z"][n] == 0:
                continue

            #print(" internal nurse " + str(n))
            #print(" last_nurse " + str(m))

            new_solution = findCandidate(last_solution, data, n)

            if len(new_solution)>0:
                zerofound = False
                last_solution = new_solution[0]
                #print("found reassignment " + str(last_solution["cost"]))
                #if len(ns) > 0:
                # it saves all intermediate results
                # Ns.extend(last_solution)
                # or just return the one that contains all changes to assignments
                
            else:
                # when first non expendable nurse is found-> returns                
                #print("found impossible reassignment, quitting")

                # quick advancing, if no reassignment done still
                # then continue until first reassignment is done
                # only if reassignments have been done that it stops here
                if not zerofound:
                    break

        # if not the same sol as solution
        if not zerofound:
            #print("finally saving all new assignments")
            Ns.append(last_solution)

        # could be made advance quicker, like using last nurse reassigned + 1...
        if last_nurse == 0:
            nurse = nurse + 1
        else:
            nurse = nurse + last_nurse

    # print("----->finished at nurse "+ str(nurse))
    # for elem in Ns:
    #    print(elem["cost"])

    return Ns





def createNeighborhood3(solution, data):
    """
        performs a firstImprovement (change nurses until no improvement)
        but starting from different positions (for n in range 0,nNurses)

    """

    # computes and stores the exceeding capacity
    exceedingNurseHours(solution, data)

    Ns = []
    new_sol = {}
    
    best_cost = solution["cost"]

    for nini in range(0, data["nNurses"]):
        print("nini " + str(nini))

        improved = True
        old_cost = solution["cost"]
        current_solution = deepcopy(solution)
        while improved:

            improved = False
            for n in range(0, data["nNurses"], 1):
                n = (n + nini) % data["nNurses"]

                if current_solution["z"][n] == 0:
                    continue

                ns = findCandidate(current_solution, data, n)

                if len(ns) > 0:
                    new_sol = ns[0]

                    # look for feasibility
                    # and for cost[new_solution] < cost[solution]
                    if isFeasible(new_sol, data) and new_sol["cost"] < old_cost:
                        improved = True
                        current_solution = new_sol
                        print(" --> Improvement: " + str(new_sol["cost"]))
                        break

            old_cost = new_sol["cost"]

        if new_sol["cost"] < best_cost:
            Ns.append(new_sol)
            best_cost = new_sol["cost"]

    return Ns




def createNeighborhood3_mp_innerloop(solution, data):
    """
        performs a firstImprovement (change nurses until no improvement)
        but starting from different positions (for n in range 0,nNurses)

        # current benchmark 0035-i-.. -> intensive ls 704s
        # with mp           0035-i-.. ->
    """

    # computes and stores the exceeding capacity
    exceedingNurseHours(solution, data)

    Ns = []
    new_sol = {}
    
    best_cost = solution["cost"]

    for nini in range(0, data["nNurses"]):
        print("nini " + str(nini))

        # for each nini use mp
        improved = True
        old_cost = solution["cost"]
        current_solution = deepcopy(solution)
        while improved:

            improved = False

            # launch each n in a difference process,
            # don't wait all to finish
            # as soon as one finishes verify if feasible or if not null
            # as soon as one is not null -> break and start again
            # current benchmark 0035-i-.. -> takes 30~80 seconds this part!
            # with mp           0035-i-.. -> takes 34~25 seconds
            
            pool = mp.Pool(processes= mp.cpu_count())
            results = [pool.apply_async(mp_aux,args=(current_solution, data, (n + nini) % data["nNurses"])) for n in range(data["nNurses"])]
            for p in results:
                new_sol = p.get()
                if new_sol:
                    pool.terminate()
                    current_solution = new_sol
                    improved = True
                    print(" --> improvement: " + str(solution["cost"]))
                    print("terminating all pool processes")
                    break          

        if current_solution["cost"] < best_cost:
            Ns.append(current_solution)
            best_cost = current_solution["cost"]

    return Ns


def createNeighborhood3_mp_aux(solution, data, nini):
    print("nini " + str(nini))

    # for each nini use mp
    improved = True
    current_solution = deepcopy(solution)
    while improved:
        improved = False

        for n in range(data["nNurses"]):
            if current_solution["z"][n] == 0:
                continue

            ns = findCandidate(current_solution, data, n)

            if len(ns) > 0:
                new_sol = ns[0]

                # look for feasibility
                # and for cost[new_solution] < cost[solution]
                if isFeasible(new_sol, data) \
                   and new_sol["cost"] < current_solution["cost"]:
                    current_solution = new_sol
                    improved = True
                    print(" --> improvement: " + str(solution["cost"]))
                    print("terminating all pool processes")
                    break

    return current_solution


def createNeighborhood3_mp_outerloop(solution, data):
    """
        performs a firstImprovement (change nurses until no improvement)
        but starting from different positions (for n in range 0,nNurses)

        # current benchmark 0035-i-.. -> intensive ls 704s
        # with mp           0035-i-.. ->
    """

    # computes and stores the exceeding capacity
    exceedingNurseHours(solution, data)

    Ns = []
    new_sol = {}
    best_cost = solution["cost"]
    pool = mp.Pool(processes=mp.cpu_count())
    results = [pool.apply(createNeighborhood3_mp_aux,
                          args=(solution, data, nini))
               for nini in range(data["nNurses"])]
    for p in results:
        new_sol = p
        if new_sol and new_sol["cost"] < best_cost:
            Ns.append(new_sol)

    return Ns


def bestImprovementLocalSearch_complex(solution, data):

    Ns = createNeighborhood3_mp_outerloop(solution, data)

    for i in range(len(Ns)):

        new_sol = Ns[i]

        if not isFeasible(new_sol, data):
            continue
        else:

            if new_sol["cost"] < solution["cost"]:

                if printlog or printlog_mainloop:
                    print("-->IMPROVEMENT")
                    print("   " + str(new_sol["cost"]) +
                          " total_w:" + str(solution["totalw"]))

                solution = new_sol

            elif (new_sol["cost"] == solution["cost"] and
                  new_sol["totalw"] < solution["totalw"]):

                if printlog or printlog_mainloop:
                    print("-->IMPROVEMENT")
                    print("   " + str(new_sol["cost"]) +
                          " total_w:" + str(solution["totalw"]))

                solution = new_sol

            elif new_sol["cost"] == solution["cost"]:

                if printlog or printlog_mainloop:
                    print("same cost" + str(new_sol["cost"]))

    return solution


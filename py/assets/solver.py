from .car import Car
from .ride import Ride
from .clean import clean

class Solver(object):
    '''Class to solve the problem.'''
    def __init__(self, raw, file_out):
        '''Initializes starting parameters for simulation.'''
        self.raw = raw
        self.output_file = file_out

        # simulation parameters
        self.rows = 0
        self.columns = 0
        self.cars = 0
        self.fleet = 0
        self.rides = 0
        self.rides_list = 0
        self.bonus = 0
        self.steps = 0

    def distance(self, start_x,start_y,end_x,end_y):
        '''Manhattan distance.'''
        return abs(end_x - start_x) + abs(end_y - start_y)

    def reachable(self, car, ride, step):
        '''Check if the car can finish ride in time.'''
        return (step + car.distance_to_start(ride) + ride.distance() <= ride.fin_time)

    def read_input(self):
        '''Function to parse raw data.'''
        res_array = self.raw.split("\n")
        res_array = [x.split(" ") for x in res_array]
        clean(res_array) # clean data
        rows, columns, cars, rides, bonus, steps = tuple([int(x) for x in res_array[0]])
        del res_array[0] # delete global simulation params from data
        rides_list = [] # create list of Ride objects with certain parameters
        for i in range(len(res_array)):
            ride = tuple([int(x) for x in res_array[i]])
            rides_list.append(Ride(i,*ride))
        return rides_list, rows, columns, cars, rides, bonus, steps

    def score(self, car, ride, step):
        '''Heuristic function to calculate the effectiveness of ride.'''
        dist_to_ride = car.distance_to_start(ride)
        ride_score = -max(dist_to_ride, ride.early - step)

        if (ride.early > step + dist_to_ride):
            ride_score += self.bonus
        return ride_score

    def print_result(self):
        '''Write output to file.'''
        with open(self.output_file, "w") as output:
            for car in self.cars:
                if len(car.rides)-1 < 0:
                    x = 0
                else:
                    x = len(car.rides)-1
                output.write(str(x) + " ")
                for i in range(len(car.rides)-1):
                    output.write(str(car.rides[i]) + " ")
                output.write("\n")

    def solve(self):
        '''Function to solve the problem. Looping through all cars and
        for each car, assign it the most effective rides until the time runs out.
        Greedy approach.'''
        self.rides_list, self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps = self.read_input()
        self.cars = [Car(i) for i in range(self.fleet)]

        for car in self.cars:
            step = 0
            while step < self.steps:
                best_ride_score = -1000000
                copied_rides = [x for x in self.rides_list]
                best_ride = None
                for ride in copied_rides:
                    if not self.reachable(car, ride, step): continue
                    scored = self.score(car, ride, step)
                    # check if it is a best ride
                    if scored >= best_ride_score:
                        best_ride = ride
                        best_ride_score = scored
                if best_ride is not None:
                    # update the time
                    step += max(car.distance_to_start(best_ride), best_ride.early - step) + best_ride.distance()
                    car.add_ride(best_ride) # assign the ride to car
                    self.rides_list.remove(best_ride) # remove from rides
                    del best_ride # delete it
                else:
                    # Break when the time runs out
                    break

        self.print_result()
        return self.cars

from .car import Car
from .ride import Ride
from .clean import clean

class Score(object):
    '''Class to get the total score of submission.'''
    def __init__(self, raw, file_out):
        '''Initializing function. Initializes starting parameters for simulation.'''
        self.raw = raw
        self.output_file = file_out
        self.distance_score = 0
        self.bonus_score = 0

        # simulation parameters
        self.rows = 0
        self.columns = 0
        self.cars = 0
        self.fleet = 0
        self.rides = 0
        self.rides_list = 0
        self.bonus = 0
        self.steps = 0
        self.cars_rides = 0

    def total(self):
        '''Returns total obtained score.'''
        return self.distance_score + self.bonus_score

    def read_input(self):
        '''Function to parse input raw data.'''
        res_array = self.raw.split("\n") # split data into arrays
        res_array = [x.split(" ") for x in res_array]
        clean(res_array) # clean missing data
        rows, columns, fleet, rides, bonus, steps = tuple([int(x) for x in res_array[0]]) # get global parameters
        del res_array[0] # delete array with global parameters
        rides_list = [] # create list of Ride objects
        for i in range(len(res_array)):
            ride = tuple([int(x) for x in res_array[i]])
            rides_list.append(Ride(i,*ride))
        return rides_list, rows, columns, fleet, rides, bonus, steps

    def score(self):
        '''Score all rides all of cars.'''
        (self.rides_list, self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps) = self.read_input()
        self.read_output() # read output
        for x in range(len(self.cars_rides)):
            car = Car(x) # instantiate Car
            for id in self.cars_rides[x]: # loop through all rides that assigned to car
                ride = self.rides_list[id] # get certain ride
                self.score_ride(car,ride) # score the ride

    def read_output(self):
        '''Function to read the result of submited file.'''
        with open(self.output_file) as file:
            res_array = file.read().split("\n") # split data
            del res_array[-1]
            res_array = [x.split(" ") for x in res_array]
            self.cars_rides = [] # get rides assigned to crtain cars
            clean(res_array) # clean data
            for i in range(len(res_array)):
                res_array[i] = [int(x) for x in res_array[i]] # convert to int
                self.cars_rides.append(res_array[i][1:])

    def score_ride(self, car, ride):
        '''Get the score of certain ride.'''
        if car.ride_scored(ride, self.steps):
            if car.early_start(ride): # If it is early start, then add bonus
                self.bonus_score += self.bonus  # bonus points
            self.distance_score += ride.distance() # add the ride distance
            car.add_ride(ride)
            return True
        else:  # car is late, so no points added
            if car.early_start(ride): # If it is early start, then add bonus
                self.bonus_score += self.bonus  # bonus points
            car.step = car.finish_time(ride) # change current step
            car.x = ride.end_x # change car position
            car.y = ride.end_y # change car position
            return False

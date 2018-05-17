from .car import Car
from .ride import Ride
from .clean import clean

class Score(object):
    """Class to get the total score of submission."""
    def __init__(self, raw, file_out):
        """Initializing function. Initializes starting parameters for simulation."""
        self.raw = raw # raw data
        self.output_file = file_out # output file
        self.distance_score = 0 # score only for distances
        self.bonus_score = 0 # score only for bonuses

        # simulation parameters
        self.rows = 0 # number of rows
        self.columns = 0 # number of columns
        self.cars = 0 # array of Car objects
        self.fleet = 0 # number of cars
        self.rides = 0 # number of rides
        self.rides_list = 0 # array of Ride objects
        self.bonus = 0 # bonus for achieving ride on time
        self.steps = 0 # number of steps in simulation
        self.cars_rides = 0 # cars with assigned rides

    def total(self):
        """Returns total obtained score."""
        return self.distance_score + self.bonus_score

    def read_input(self):
        """Function to parse input raw data."""
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
        """Score all rides of all cars."""
        (self.rides_list, self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps) = self.read_input()
        self.read_output() # read output
        for x in range(len(self.cars_rides)):
            car = Car(x) # instantiate Car
            for id in self.cars_rides[x]: # loop through all rides that assigned to car
                ride = self.rides_list[id] # get certain ride
                self.score_ride(car,ride) # score the ride

    def read_output(self):
        """Function to read the result of submission file."""
        with open(self.output_file) as file:
            res_array = file.read().split("\n") # split data
            del res_array[-1] # delete last empty string
            res_array = [x.split(" ") for x in res_array]
            self.cars_rides = [] # get rides assigned to crtain cars
            clean(res_array) # clean data
            for i in range(len(res_array)):
                res_array[i] = [int(x) for x in res_array[i]] # convert to int
                self.cars_rides.append(res_array[i][1:])

    def score_ride(self, car, ride):
        """Get the score of certain ride."""
        if car.ride_scored(ride, self.steps): # if the car finish ride on time
            if car.early_start(ride): # If it is early start, then add bonus
                self.bonus_score += self.bonus  # bonus points
            self.distance_score += ride.distance() # add the ride distance
            car.add_ride(ride) # assign ride to car
            return True
        else:  # car is late, so no points added
            if car.early_start(ride): # If it is early start, then add bonus
                self.bonus_score += self.bonus  # bonus points
            car.step = car.finish_time(ride) # change current step
            car.x = ride.end_x # change car position
            car.y = ride.end_y # change car position
            return False

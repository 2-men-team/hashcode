from .car import Car
from .ride import Ride
from .clean import clean
import random
import math

class Visualizer(object):
    """Class for visualization of submission."""
    def __init__(self, canv, raw, file_out):
        """Initializes starting parameters for simulation."""
        self.canv = canv # canvas widget
        self.raw = raw # raw data
        self.output_file = file_out # output file

        # simulation parameters
        self.rows = 0 # number of rows
        self.columns = 0 # number of columns
        self.cars = 0 # array of Car objects
        self.fleet = 0 # number of cars
        self.rides = 0 # number of rides
        self.rides_list = 0 # array of Ride objects
        self.bonus = 0 # bonus
        self.steps = 0 # total steps in simulation

    def parsed_output(self):
        """Function to parse output file."""
        with open(self.output_file) as file:
            res_array = file.read().split("\n") # read data
            del res_array[-1] # delete last element ''
            res_array = [x.split(" ") for x in res_array] # split data
            self.cars_rides = []
            clean(res_array) # clear data
            for i in range(len(res_array)):
                res_array[i] = [int(x) for x in res_array[i]] # convert to integer
                self.cars_rides.append(res_array[i][1:])
        cars = [] # create array of carsu
        for x in range(self.fleet):
            cars.append(Car(x)) # create Car object
            cars[-1].rides += self.cars_rides[x] # assign to car it's rides
        return cars # return array of Car objects

    def parsed_input(self):
        """Function to parse input raw data."""
        res_array = self.raw.split("\n") # split data
        res_array = [x.split(" ") for x in res_array] # split into array of arrays
        clean(res_array) # clean data
        self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps = tuple([int(x) for x in res_array[0]])
        del res_array[0] # delete array with global parameters
        self.rides_list = []
        for i in range(len(res_array)):
            ride = tuple([int(x) for x in res_array[i]])
            self.rides_list.append(Ride(i,*ride)) # create list of Ride objects
        return self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps

    def visualize(self):
        """Visualization function."""
        self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps = self.parsed_input()
        self.cars = self.parsed_output() # get array of Car objects

        for x in range(100): # visualize 100 tandom rides
            ride_id = random.randint(0, len(self.rides_list)-1) if(len(self.rides_list) > 100) else x # pick random ride
            ride = self.rides_list[ride_id] # get Ride object by id
            current_car = self.find(ride) # find car, which this ride was assigned to
            bonus_color, ride_color = self.color(ride, current_car) # find colors for this ride
            self.draw(ride, bonus_color, ride_color) # draw ride

    def find(self, ride):
        """Find Car to which the ride was assigned"""
        for car in self.cars:
            if ride.id in car.rides:
                return car
        return None # return None if the ride wasn't assigned

    def color(self, ride, car):
        """Get the color of ride."""
        if car is None: # the ride wasn't taken
            return "red", "red"

        car.x = 0 # initialize car coordinate x
        car.y = 0 # initialize car coordinate y
        car.step = 0 # initialize car step
        bonus_color, ride_color = None, None # set colors to None
        index = car.rides.index(ride.id) # get the order number of ride id
        # when we reach the ride, we can define it's colors

        for i in range(len(car.rides)):
            dist_to_ride = abs(car.x - self.rides_list[car.rides[i]].start_x) + abs(car.y - self.rides_list[car.rides[i]].start_y)
            car.step += dist_to_ride # update step
            car.x = self.rides_list[car.rides[i]].start_x # update x coord
            car.y = self.rides_list[car.rides[i]].start_y # update y coord
            if i == index: break # stop simulation when reached the ride
            car.step += self.rides_list[car.rides[i]].distance() # update ride
            car.x = self.rides_list[car.rides[i]].end_x # update coord x
            car.y = self.rides_list[car.rides[i]].end_y # update coord y

        if ride.early > car.step: # define the bonus color
            car.step = ride.early
            bonus_color = 'yellow'

        if car.step + ride.distance() <= ride.fin_time: # define ride color
            ride_color = 'green'
        else:
            ride_color = 'orange'

        if bonus_color != 'yellow': # set default bonus color if it wasn't defined
            bonus_color = ride_color
        return bonus_color, ride_color

    def draw(self, ride, bonus_color, ride_color):
        """Draw the ride on canvas."""
        scale_x = int(self.canv['width'])/self.rows # calc the x axis scale
        scale_y = int(self.canv['height'])/(1.1*self.columns) # calc the y axis scale

        # scale coordinates
        start_x_scaled = math.floor(ride.start_x*scale_x)
        start_y_scaled = math.floor(int(self.canv['height']) - ride.start_y*scale_y)-40
        end_x_scaled = math.floor(ride.end_x*scale_x)
        end_y_scaled = math.floor(int(self.canv['height']) - ride.end_y*scale_y)-40

        # create 4 points to draw dot
        x1, y1 = (start_x_scaled - 3), (start_y_scaled - 3)
        x2, y2 = (start_x_scaled + 3), (start_y_scaled + 3)
        self.canv.create_oval(x1, y1, x2, y2, fill=bonus_color, outline="")

        # draw 2 lines
        self.canv.create_line(start_x_scaled,start_y_scaled,end_x_scaled,start_y_scaled,width=2,fill=ride_color)
        self.canv.create_line(end_x_scaled,start_y_scaled,end_x_scaled,end_y_scaled,width=2,fill=ride_color)

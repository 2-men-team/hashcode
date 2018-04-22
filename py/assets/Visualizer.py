from .Car import Car
from .Ride import Ride
import random
import math

class Visualizer(object):
    def __init__(self, canv, raw, file_out):
        self.canv = canv
        self.raw = raw
        self.output_file = file_out

        # input and output
        self.input = 0
        self.output = 0

        # simulation parameters
        self.rows = 0
        self.columns = 0
        self.cars = 0
        self.fleet = 0
        self.rides = 0
        self.rides_list = 0
        self.bonus = 0
        self.steps = 0

    def parsed_output(self):
        with open(self.output_file) as file:
            res_array = file.read().split("\n")
            del res_array[-1]
            res_array = [x.split(" ") for x in res_array]
            self.cars_rides = []
            for i in range(len(res_array)):
                if(res_array[i][-1] == ''):
                    del res_array[i][-1]
                res_array[i] = [int(x) for x in res_array[i]]
                self.cars_rides.append(res_array[i][1:])
        cars = []
        for x in range(self.fleet):
            cars.append(Car(x))
            cars[-1].rides += self.cars_rides[x]
        return cars

    def parsed_input(self):
        res_array = self.raw.split("\n")
        res_array = [x.split(" ") for x in res_array]
        self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps = tuple([int(x) for x in res_array[0]])
        del res_array[0], res_array[-1]
        self.rides_list = []
        for i in range(len(res_array)):
            ride = tuple([int(x) for x in res_array[i]])
            self.rides_list.append(Ride(i,*ride))
        return self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps

    def visualize(self):
        self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps = self.parsed_input()
        self.cars = self.parsed_output()
        for x in range(100):
            ride_id = random.randint(0, len(self.rides_list)-1) if(len(self.rides_list) > 100) else x
            ride = self.rides_list[ride_id]
            current_car = self.find(ride)
            bonus_color, ride_color = self.color(ride, current_car)
            self.draw(ride, bonus_color, ride_color)

    def find(self, ride):
        for car in self.cars:
            if ride.id in car.rides:
                return car
        return None

    def color(self, ride, car):
        if car is None:
            return "red", "red"

        car.x = 0
        car.y = 0
        car.step = 0
        bonus_color, ride_color = '', ''
        index = car.rides.index(ride.id)
        for i in range(len(car.rides)):
            dist_to_ride = abs(car.x - self.rides_list[car.rides[i]].start_x) + abs(car.y - self.rides_list[car.rides[i]].start_y)
            car.step += dist_to_ride
            car.x = self.rides_list[car.rides[i]].start_x
            car.y = self.rides_list[car.rides[i]].start_y
            if i == index:
                break
            car.step += self.rides_list[car.rides[i]].distance()
            car.x = self.rides_list[car.rides[i]].end_x
            car.y = self.rides_list[car.rides[i]].end_y

        if ride.early > car.step:
            car.step = ride.early
            bonus_color = 'yellow'

        if car.step + ride.distance() <= ride.fin_time:
            ride_color = 'green'
        else:
            ride_color = 'orange'
        if bonus_color != 'yellow':
            bonus_color = ride_color
        return bonus_color, ride_color



    def draw(self, ride, bonus_color, ride_color):
        scale_x = int(self.canv['width'])/self.rows
        scale_y = int(self.canv['height'])/self.columns

        start_x_scaled = math.floor(ride.start_x*scale_x)
        start_y_scaled = math.floor(ride.start_y*scale_y)
        end_x_scaled = math.floor(ride.end_x*scale_x)
        end_y_scaled = math.floor(ride.end_y*scale_y)

        x1, y1 = (start_x_scaled - 3), (start_y_scaled - 3)
        x2, y2 = (start_x_scaled + 3), (start_y_scaled + 3)
        self.canv.create_oval(x1, y1, x2, y2, fill=bonus_color, outline="")

        self.canv.create_line(start_x_scaled,start_y_scaled,end_x_scaled,start_y_scaled,width=3,fill=ride_color)
        self.canv.create_line(end_x_scaled,start_y_scaled,end_x_scaled,end_y_scaled,width=3,fill=ride_color)

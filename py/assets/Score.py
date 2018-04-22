from .Car import Car
from .Ride import Ride

# classes
class Score(object):
    def __init__(self, raw, file_out):
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
        return self.distance_score + self.bonus_score

    def read_input(self):
        res_array = self.raw.split("\n")
        res_array = [x.split(" ") for x in res_array]
        rows, columns, cars, rides, bonus, steps = tuple([int(x) for x in res_array[0]])
        del res_array[0], res_array[-1]
        rides_list = []
        for i in range(len(res_array)):
            ride = tuple([int(x) for x in res_array[i]])
            rides_list.append(Ride(i,*ride))
        return rides_list, rows, columns, cars, rides, bonus, steps

    def score(self):
        (self.rides_list, self.rows, self.columns, self.fleet, self.rides, self.bonus, self.steps) = self.read_input()
        self.read_output()
        for x in range(len(self.cars_rides)):
            car = Car(x)
            for id in self.cars_rides[x]:
                ride = self.rides_list[id]
                self.score_ride(car,ride)

    def read_output(self):
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

    def score_ride(self, car, ride):
        if car.ride_scored(ride, self.steps):
            if car.early_start(ride):
                self.bonus_score += self.bonus  # bonus points
            self.distance_score += ride.distance()
            car.add_ride(ride)
            return True
        else:  # late
            car.step = car.finish_time(ride)
            car.x = ride.end_x
            car.y = ride.end_y
            return False

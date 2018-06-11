import sys

file_in = sys.argv[1]
file_out = sys.argv[2]


def distance(start_x,start_y,end_x,end_y):
    return abs(end_x - start_x) + abs(end_y - start_y)

# classes
class Score(object):
    def __init__(self):
        self.distance_score = 0
        self.bonus_score = 0

    def total(self):
        return self.distance_score + self.bonus_score

class Ride(object):
    def __init__(self, id,start_x,start_y,end_x,end_y,early,fin_time):
        self.id = id
        self.start_x = start_x
        self.start_y = start_y
        self.end_x = end_x
        self.end_y = end_y
        self.early = early
        self.fin_time = fin_time

    def distance(self):
        return abs(self.start_x - self.end_x) + abs(self.start_y - self.end_y)

class Car(object):
    def __init__(self):
        self.x = 0
        self.y = 0
        self.rides = []
        self.step = 0

    def distance_to_pos(self,end_x,end_y):
        return distance(self.x, self.y, end_x, end_y)

    def distance_to_start(self,ride):
        return distance(self.x,self.y,ride.start_x,ride.start_y)

    def wait_time(self,ride):
        if ride.early > self.step + self.distance_to_start(ride):
            return (ride.early - (self.step + self.distance_to_start(ride)))
        else:
            return 0

    def finish_time(self, ride):
        return self.step + self.distance_to_start(ride) + self.wait_time(ride) + ride.distance()

    def early_start(self, ride):
        return self.step + self.distance_to_start(ride) <= ride.early

    def ride_scored(self, ride, steps):
        return (self.finish_time(ride) <= min(ride.fin_time, steps))

    def add_ride(self, ride):
        self.rides.append(ride.id)
        start_time = self.step + self.distance_to_start(ride)
        if ride.early >= start_time:
            self.step = ride.early + ride.distance()
        else:
            self.step = start_time + ride.distance()
        self.x = ride.end_x
        self.y = ride.end_y

# functions
def read_input(input_file):
    with open(input_file) as file:
        res_array = file.read().split("\n")
        res_array = [x.split(" ") for x in res_array]
        rows, columns, cars, rides, bonus, steps = tuple([int(x) for x in res_array[0]])
        del res_array[0], res_array[-1]
        rides_list = []
        for i in range(len(res_array)):
            ride = tuple([int(x) for x in res_array[i]])
            rides_list.append(Ride(i,*ride))
    return rides_list, rows, columns, cars, rides, bonus, steps

def read_output(output_file):
    with open(output_file) as file:
        res_array = file.read().split("\n")
        if not res_array[-1]: # line is empty
          del res_array[-1]
        res_array = [x.split(" ") for x in res_array]
        cars_rides = []
        for i in range(len(res_array)):
            if(res_array[i][-1] == ''):
                del res_array[i][-1]
            res_array[i] = [int(x) for x in res_array[i]]
            cars_rides.append(res_array[i][1:])
        return cars_rides

def score_ride(car, ride, score, bonus, steps):
    if car.ride_scored(ride, steps):
        if car.early_start(ride):
            score.bonus_score += bonus  # bonus points
        score.distance_score += ride.distance()
        car.add_ride(ride)
        return True
    else:  # late
        car.step = car.finish_time(ride)
        car.x = ride.end_x
        car.y = ride.end_y
        return False

def calculate_score(input_file,output_file):
    (rides_list, rows, columns, vehicles, rides, bonus, steps) = read_input(file_in)
    cars_rides = read_output(output_file)
    score = Score()
    for car_rides in cars_rides:
        car = Car()
        for id in car_rides:
            ride = rides_list[id]
            score_ride(car,ride,score,bonus,steps)
    return score

def output(score, a, b, output_file="dataset_py.csv"):
    with open(output_file, "a") as output:
        output.write(str(a) + " " + str(b) + " " + str(score) + "\n")

# usage
scored = calculate_score(file_in, file_out)
print(scored.total())
#output(scored.total())

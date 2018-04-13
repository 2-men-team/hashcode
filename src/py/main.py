import sys

file_in = sys.argv[1]
file_out = sys.argv[2]

# main distance function
def distance(start_x,start_y,end_x,end_y):
    return abs(end_x - start_x) + abs(end_y - start_y)

# classes
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
    def __init__(self, id):
        self.id  = id
        self.x = 0
        self.y = 0
        self.rides = []
        self.steps_left = 0

    def distance_to_start(self,ride):
        return distance(self.x,self.y,ride.start_x,ride.start_y)

    def add_ride(self, ride):
        self.rides.append(ride.id)
        self.x = ride.end_x
        self.y = ride.end_y

# functions
def main(input_file):
    rides_list, rows, columns, fleet, rides, bonus, steps = read_input(input_file)
    cars = [Car(i) for i in range(fleet)]

    for car in cars:
        step = 0
        while step < steps:
            best_ride_score = -1000000
            copied_rides = [x for x in rides_list]
            best_ride = None
            for ride in copied_rides:
                if not reachable(car, ride, step): continue
                scored = score(car, ride, bonus, step)

                if scored >= best_ride_score:
                    best_ride = ride
                    best_ride_score = scored
            if not best_ride == None:
                step += max(car.distance_to_start(best_ride), best_ride.early - step) + best_ride.distance()
                car.add_ride(best_ride)
                rides_list.remove(best_ride)
                del best_ride
            else:
                break
    return cars

def reachable(car, ride, step):
    return (step + car.distance_to_start(ride) + ride.distance() <= ride.fin_time)

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

def score(car, ride, bonus, step):
    dist_to_ride = car.distance_to_start(ride)
    ride_score = -*max(dist_to_ride, ride.early - step)

    if (ride.early > step + dist_to_ride):
        ride_score += b*bonus

    return ride_score

def print_result(output_file, cars):
    with open(output_file, "a") as output:
        for car in cars:
            if len(car.rides)-1 < 0:
                x = 0
            else:
                x = len(car.rides)-1
            output.write(str(x) + " ")
            for i in range(len(car.rides)-1):
                output.write(str(car.rides[i]) + " ")
            output.write("\n")

cars = main(file_in)
print_result(file_out, cars)

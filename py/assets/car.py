class Car(object):
    '''Class to simulate Car activities.'''
    def __init__(self, id):
        self.id  = id # id of car
        self.x = 0 # current x coordinate
        self.y = 0 # current y coordinate
        self.rides = [] # ride ids assigned to the car
        self.step = 0 # current step
        self.steps_left = 0 # steps left to end the ride (This is optional)

    def distance_to_pos(self,end_x,end_y):
        '''Calculate distance from car to certain position.'''
        return abs(self.x - end_x) + abs(self.y - end_y)

    def distance_to_start(self,ride):
        '''Calculate distance from car to the start of ride.'''
        return abs(self.x - ride.start_x) + abs(self.y - ride.start_y)

    def wait_time(self,ride):
        '''Calculate wait time of car if there is one.'''
        if ride.early > self.step + self.distance_to_start(ride):
            return (ride.early - (self.step + self.distance_to_start(ride)))
        else:
            return 0

    def finish_time(self, ride):
        '''Calculate time, when car will finish the ride.'''
        return self.step + self.distance_to_start(ride) + self.wait_time(ride) + ride.distance()

    def early_start(self, ride):
        '''Check if car will start the ride early.'''
        return self.step + self.distance_to_start(ride) <= ride.early

    def ride_scored(self, ride, steps):
        '''Check if the ride will be scored.'''
        return (self.finish_time(ride) <= min(ride.fin_time, steps))

    def add_ride(self, ride):
        '''Assign ride the car.'''
        self.rides.append(ride.id)
        start_time = self.step + self.distance_to_start(ride)
        if ride.early >= start_time:
            self.step = ride.early + ride.distance()
        else:
            self.step = start_time + ride.distance()
        self.x = ride.end_x
        self.y = ride.end_y

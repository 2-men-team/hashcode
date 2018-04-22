class Car(object):
    def __init__(self, id):
        self.id  = id
        self.x = 0
        self.y = 0
        self.rides = []
        self.step = 0
        self.steps_left = 0

    def distance_to_pos(self,end_x,end_y):
        return abs(self.x - end_x) + abs(self.y - end_y)

    def distance_to_start(self,ride):
        return abs(self.x - ride.start_x) + abs(self.y - ride.start_y)

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

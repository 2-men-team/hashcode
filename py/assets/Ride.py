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

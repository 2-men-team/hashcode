class Ride(object):
    '''Class to simulate Ride activities.'''
    def __init__(self, id,start_x,start_y,end_x,end_y,early,fin_time):
        self.id = id # id of ride
        self.start_x = start_x # x tart coordinate
        self.start_y = start_y # y start coordinte
        self.end_x = end_x # x end coordinate
        self.end_y = end_y # y end coordinate
        self.early = early # time of early start
        self.fin_time = fin_time # finish time

    def distance(self):
        '''Returns the whole distance of ride.'''
        return abs(self.start_x - self.end_x) + abs(self.start_y - self.end_y)

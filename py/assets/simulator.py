from .solver import Solver
from .score import Score
from .clean import clean

class Simulator(object):
    '''Class to simulate the whole solution process.'''
    def __init__(self, raw, file_out):
        '''Run the validation for the data;
        If data is valid, then runs Solver to solve it and Score to obtain
        the total score of solution.'''
        self.raw = raw

        # solve if raw is valid
        if self.validate():
            self.solver = Solver(raw, file_out)
            self.solver.solve()
            self.scorer = Score(raw, file_out)
            self.scorer.score()
            self.score = self.scorer.total()

    def validate(self):
        '''Function to check if the input data is valid.'''
        valid = True
        try:
            # splitting the data into arrays
            res_array = self.raw.split("\n")
            res_array = [x.split(" ") for x in res_array]
            # cleaning missing data
            clean(res_array)

            res_array[0] = [int(x) for x in res_array[0]]
            for i in range(1, len(res_array)):
                res_array[i] = [int(x) for x in res_array[i]] # convert to integers
                # conditions for the valid data
                if (len(res_array) - 1) != res_array[0][3]: valid = False; break
                if (len(res_array[i]) != 6): valid = False; break
                if res_array[i][0] > res_array[0][0] or res_array[i][0] < 0: valid = False
                if res_array[i][1] > res_array[0][1] or res_array[i][1] < 0: valid = False
                if res_array[i][2] > res_array[0][0] or res_array[i][2] < 0: valid = False
                if res_array[i][3] > res_array[0][1] or res_array[i][3] < 0: valid = False
                if res_array[i][4] > res_array[0][5] or res_array[i][4] < 0: valid = False
                if res_array[i][5] > res_array[0][5] or res_array[i][5] < 0: valid = False
                if not valid: break
        except (ValueError, TypeError, AttributeError):
            valid = False
        return valid

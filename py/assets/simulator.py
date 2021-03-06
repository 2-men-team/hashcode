from .solver import Solver
from .score import Score
from .clean import clean

class Simulator(object):
    """Class to simulate the whole solution process."""
    def __init__(self, raw, file_out, file_in=None):
        """Run the validation for the data;
        If data is valid, then runs Solver to solve it and Score to obtain
        the total score of solution."""
        self.raw = raw # raw data

        # solve if raw is valid
        if self.validate():
            self.solver = Solver(raw, file_out, file_in) # instantiate Solver
            self.solver.solve() # solve problem
            self.scorer = Score(raw, file_out) # instantiate Score
            self.scorer.score() # score the result
            self.score = self.scorer.total() # get the total score

    def validate(self):
        """Function to check if the input data is valid."""
        valid = True
        try:
            res_array = self.raw.split("\n") # splitting the data into arrays
            res_array = [x.split(" ") for x in res_array]
            clean(res_array) # cleaning missing data

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
        except (ValueError, TypeError, AttributeError): # catch errors
            valid = False
        return valid

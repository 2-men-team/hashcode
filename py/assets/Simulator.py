from .Solver import Solver
from .Score import Score

class Simulator(object):
    def __init__(self, raw, file_out):
        self.raw = raw

        # solve if raw is valid
        if self.validate(raw):
            self.solver = Solver(raw, file_out)
            self.solver.solve()
            self.scorer = Score(raw, file_out)
            self.scorer.score()
            self.score = self.scorer.total()
        else:
            print("Invalid input format.")

    def validate(self, raw):
        valid = True
        try:
            res_array = self.raw.split("\n")
            res_array = [x.split(" ") for x in res_array]
            del res_array[-1]

            for i in range(len(res_array)):
                if(len(res_array[i]) != 6):
                    valid = False
                    break
                res_array[i] = [int(x) for x in res_array[i]]
        except ValueError:
            valid = False

        return valid

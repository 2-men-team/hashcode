import sys
sys.path.insert(0, '/home/napoleon/course_work/hashcode/py/assets')
from solver import Solver
from score import Score

def read(input):
    with open(input) as file:
        return file.read()

def log(score, a, b, log_file="/home/napoleon/course_work/hashcode/py/tune/dataset.csv"):
    with open(log_file, "a") as file:
        file.write(str(a) + "," + str(b) + "," + str(score) + "\n")

def main():
    files = [
        "/home/napoleon/course_work/hashcode/datasets/b_should_be_easy.in",
        "/home/napoleon/course_work/hashcode/datasets/c_no_hurry.in",
        "/home/napoleon/course_work/hashcode/datasets/d_metropolis.in",
        "/home/napoleon/course_work/hashcode/datasets/e_high_bonus.in"
    ]
    _a = [0,1,2,3,4,5]
    _b = [0,1,2,3,4,5]
    for a in _a:
        for b in _b:
            score = 0
            for file in files:
                raw = read(file)
                file_out = file[:-2] + "out"
                solver = Solver(raw, file_out, a, b)
                solver.solve()
                scorer = Score(raw, file_out)
                scorer.score()
                score += scorer.total()
                print(scorer.total(), file)
            print(a, b, score)
            log(score, a, b)

if __name__ == "__main__":
    main()

def clean(data):
    '''Function to clean data from empty fields.'''
    for dat in data:
        if dat[-1] == '': # check for empty strings
            del dat[-1]
    while len(data[-1]) == 0: # check for empty arrays
        del data[-1]

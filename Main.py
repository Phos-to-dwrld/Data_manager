import json
import os


#note to self: single line of input for all variables instead of 10

def add_elemnts(ext_dict):
    key_name = input('student name > ')
    value_list = []
    department = input('department >  ')
    age = input('age >  ')
    sub_no = input('no of subject >  ')
    disability = input('diability >')
    student_rank = input('rank > ')
    parameters =[department,age,sub_no,disability,student_rank]
    y = value_list.extend(parameters)
    ext_dict[key_name] = value_list
    #return parameters

def display_info(external_dict):
    for s_name, dets in external_dict.items():
        print(f'Name :  {s_name}')
        print(f'Department :  {dets[0]}')
        print(f'Age :  {dets[1]}')
        print(f'No of subjects :  {dets[2]}')
        print(f'Disabilities :  {dets[3]}')
        print(f'Student Rank :  {dets[4]}')

def load_students(filename):
    if os.path.exists(filename):
        with open(filename, 'r') as file:
            return json.load(file)
    return {}

def save_students(data, filename):
    with open(filename, 'w') as file:
        json.dump(data, file, indent=4)

def delete_student(ext_dict):
    name = input("who's information would you like you delete > ")
    if name in ext_dict:
        del ext_dict[name]
    else:
        return 'name  not found'
    
def search_student():
    name = input('Who would you like to search for >  ')
    filelist = ['jss1.json', 'jss2.json', 'jss3.json', 'ss1.json', 'ss2.json', 'ss3.json']
    for x in filelist:
        target_search = load_students(x)
        if name in target_search:
            print('searching...')
            print(f'Name: {name}')
            print(f'Department: {target_search[name][0]}')
            print(f'Age: {target_search[name][1]}')
            print(f'No of subjects: {target_search[name][2]}')
            print(f'Disabilities: {target_search[name][3]}')
            print(f'Student Rank: {target_search[name][4]}')
            return
    print('Name not found.')

def directory():
    line = '-' * 25
    print(line)
    print('welcome to the data bank!')
    print ('what will you like to do?')
    print('''
        search   :  to search for a student
        add      :  to add a students info
        load     :  to get the class info 
        delete   :  to delete a stdent' info
        directory:  to get the command list
        terminate:  to end the process or exit
        update   :  to edit a student's info
        export   :  to save all the students'd info into one file
        
''')

def update_student():
    s_class = input("Which class is the student in > ")
    data = load_students(s_class)
    name = input("Enter the student's name to update > ")
    if name in data:
        print(f"Current details: {data[name]}")
        department = input('New department > ')
        age = input('New age > ')
        sub_no = input('New no of subjects > ')
        disability = input('New disability > ')
        student_rank = input('New rank > ')
        data[name] = [department, age, sub_no, disability, student_rank]
        save_students(data, s_class)
        print('Student information updated successfully.')
    else:
        print('Student not found.')

def export_all_students():
    filelist = ['jss1.json', 'jss2.json', 'jss3.json', 'ss1.json', 'ss2.json', 'ss3.json']
    all_students = {}
    for file in filelist:
        data = load_students(file)
        for name, details in data.items():
            all_students[name] = details
    save_students(all_students, 'all_students.json')
    print('All student data exported to all_students.json')
    
directory()
while True:
    command  = input('command > ')
    if command.lower()  == 'search':
        search_student()
        print('student successfully found!')
    elif command.lower()  == 'add':
        print('what class will you like to add the student to the class')
        s_class = input('class : ')
        a = load_students(s_class)
        add_elemnts(a)
        save_students(a, s_class)
    elif command.lower()  == 'load':
        print('what class woud you like to load')
        s_class = input('class : ')
        load_students(s_class)
        display_info(s_class)
        print('successfully loaded !')
    elif command.lower()  == 'delete':
        print('which info would you like you delete')
        s_class = input('class :  ')
        lda = load_students(s_class)
        delete_student(lda)
        save_students(lda,s_class)
        print('successfully deleted!')
    elif command.lower() == 'directory':
        directory()
    elif command.lower() == 'terminate':
        print('exiting')
        break
    elif command.lower() == 'update':
        update_student()
    elif command.lower() == 'export':
        export_all_students()
    else:
        print('invalid command...')
        continue



# 모듈 못찾는 에러 발생하면 path 추가해주기
import sys
import os
try:
    sys.path.append(os.getcwd())
except ImportError:
    raise ImportError('Import Fail')


from emaillistapp import model              # model 전체를 가져오기
# from emaillistapp.model import findall    # 함수만 가져오기


def run_list():
    result = model.findall()
    idx = 1
    # for res in result:
    #     print(f'{idx} : {res["first_name"]}{res["last_name"]} : {res["email"]}')
    #     idx += 1

    for index, res in enumerate(result):
        print(f'{idx} : {res["first_name"]}{res["last_name"]} : {res["email"]}')
        idx += 1


def run_add():
    firstname = input('first name : ')
    lastname = input('last name : ')
    email = input('email : ')

    model.insert(firstname, lastname, email)

    # 추가 후 DB 출력
    run_list()


def run_delete():
    email = input('email : ')

    model.deletebyemail(email)

    # 추가 후 DB 출력
    run_list()


def main():
    while True:
        cmd = input(f'(l)list, (a)add, (d)delete (q)quit > ')

        if cmd == 'q':
            break
        elif cmd == 'l':
            run_list()
        elif cmd == 'a':
            run_add()
        elif cmd == 'd':
            run_delete()
        else:
            print('unknown')


if __name__ == '__main__':
    main()

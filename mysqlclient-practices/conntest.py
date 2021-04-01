from MySQLdb import connect # Alt + Enter

# db와 연결하기
try :
    db = connect(
        user='webdb',
        password='webdb',
        host='localhost',
        port=3306,
        db='webdb',
        charset='utf8')
    print('Connect')
except Exception as e :
    print(f'Error : {e}')     # f'{객체명}' 으로 print format 설정 가능


















# Alt + Enter : import 단축키
from MySQLdb import connect
from MySQLdb.cursors import DictCursor

try :
    # DB연결
    db = connect(
        user='webdb',
        password='webdb',
        host='localhost',
        port=3306,
        db='webdb',
        charset='utf8')

    # 쿼리문을 사용하기 위해 cursor를 생성 : row 선택을 위한 커서
    # DictCursor : 결과를 dictionay list로 받는다
    cursor = db.cursor(DictCursor)

    # SQL 실행 : 쿼리문 가져올때 ; 빼고 가져올 것
    sql = 'select no, first_name, last_name, email from emaillist order by no desc'
    cursor.execute(sql)

    # 결과 받아오기
    result = cursor.fetchall()

    # 자원 정리
    cursor.close()  # 커서
    db.close()      # DB연결 끊기

    # 결과 보기
    for res in result :
        print(res)


except Exception as e :
    print(f'Error : {e}') # Alt + Enter : import 단축키


















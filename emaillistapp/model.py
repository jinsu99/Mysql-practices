from MySQLdb import connect
from MySQLdb.cursors import DictCursor

# app.py에서 사용할 함수를 정의
# model.conn() : DB연결부분이 중복되므로 함수로 정의하기
# app.run_list() = model.findall()
# app.run_add() = model.insert()


def conn():
    return connect(
        user='webdb',
        password='webdb',
        host='localhost',
        port=3306,
        db='webdb',
        charset='utf8')


def deletebyemail(email):
    try:
        # DB연결
        db = conn()

        # cursor 생성
        cursor = db.cursor()

        # SQL 실행

        sql = "delete from emaillist where email = %s"
        count = cursor.execute(sql, (email, ))

        # DB 반영
        db.commit()

        # 자원 정리
        cursor.close()  # 커서
        db.close()      # DB연결 끊기

        # 결과 반환
        return count == 1

    except Exception as e:
        print(f'Error : {e}')  # Alt + Enter : import 단축키


def findall():
    try:
        # DB연결
        db = conn()

        # cursor를 생성
        cursor = db.cursor(DictCursor)

        # SQL 실행
        sql = 'select no, first_name, last_name, email from emaillist order by no desc'
        cursor.execute(sql)

        # 결과 받아오기
        result = cursor.fetchall()

        # 자원 정리
        cursor.close()  # 커서
        db.close()      # DB연결 끊기

        # 결과 반환
        return result

    except Exception as e:
        print(f'Error : {e}')  # Alt + Enter : import 단축키


def insert(firstname, lastname, email):
    try:
        # DB연결
        db = conn()

        # cursor 생성
        cursor = db.cursor()

        # SQL 실행
        sql = "insert into emaillist values(null, %s, %s, %s)"
        count = cursor.execute(sql, (firstname, lastname, email))   # 바인딩

        # DB 반영
        db.commit()

        # 자원 정리
        cursor.close()  # 커서
        db.close()      # DB연결 끊기

        # 결과 반환
        return count == 1

    except Exception as e:
        print(f'Error : {e}')  # Alt + Enter : import 단축키























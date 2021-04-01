# Alt + Enter : import 단축키
from MySQLdb import connect

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
    # insert를 위한 cursor이므로 사용할 필요가 없다.
    cursor = db.cursor()

    # SQL 실행 : 쿼리문 가져올때 ; 빼고 가져올 것
    # insert 문 넣기
    sql = "insert into emaillist values(null, '이', '유리', 'yuri@gmail.com')"
    # cursor 실행 결과로 정상실행된 쿼리문의 개수를 반환
    count = cursor.execute(sql)

    # 결과 받아오기 → insert문이라 받아올 필요 없음
    # result = cursor.fetchall()

    # commit을 해줘야 DB에 반영된다
    # commit없이 insert가 진행되면, 실제로 테이블에 적용되지 않지만 pk는 증가.
    db.commit()

    # 자원 정리
    cursor.close()  # 커서
    db.close()      # DB연결 끊기

    # 결과 보기
    print(f'실행결과 : {count == 1}')


except Exception as e :
    print(f'Error : {e}') # Alt + Enter : import 단축키
















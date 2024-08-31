# DGU_portal_flutter

## API
| Methods | 제목                      | 내용                                                 |
|-----|-------------------------|----------------------------------------------------|
| Get | /                       | api 연결 여부를 반환합니다                                   |
| Get | /num                    | 리스트 요소의 갯수를 반환합니다.                                 |
| Get | /information/empprgnoti | {'link': '링크 주소','고유번호': '제목'} 의 형태로 취업 정보를 전달합니다. |
| Get | /information/acdnotice  | {'link': '링크 주소','고유번호': '제목'} 의 형태로 학사 정보를 전달합니다.          |
| Get | /information/generalnotice | {'link': '링크 주소','고유번호': '제목'} 의 형태로 일반 정보를 전달합니다.          |


## ERD
(추가 예정)

## 배포 방법
![poster](https://cdn.discordapp.com/attachments/1265717766053433405/1271770694144884786/aws.png?ex=66b88c41&is=66b73ac1&hm=3cf5ffcce858e25bc609c4bced9cdf11c16837f8338d2998e1ae83dc2a6352e5&)

[server_file](./server_file) 파일 내부의 .zip 파일을 AWS EB에 업로드하여 배포
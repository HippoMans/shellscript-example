# shellscript-example



## make_partitions.sh 스크립트 내용
* make_partitions.sh 스크립트 내용은 disk의 partition을 용량에 따라 자동으로 생성하고 cache* 디렉토리와 연결
* ext4로 파일시스템 변경


## node_exporter_install_service.sh 스크립트 내용
* node_exporter 1.3.0 버전 다운로드
* service를 통해 node_exporter를 실행 및 관리
* service를 통해 관리하기에 일정정도 자원이 필요


## node_exporter_install_rclocal.sh 스크립트 내용
* node_exporter 1.3.0 버전 다운로드
* rc-local을 통해 부팅 시 node_exporter를 실행 할 수 있게 관리
* 부팅시에만 실행하기에 OS 정상 실행 중에 node_exporter의 관리는 불가




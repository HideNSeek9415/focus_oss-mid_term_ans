#!/bin/bash

data=$1

nhanthongtin() {
	read -p "Giao thức: " gt
	read -p "Địa chỉ IP: " ip
	read -p "Hệ điều hành: " hdh
	read -p "Thời gian: " tg
	echo "$gt $ip $hdh $tg" >> $data
}

xuatthongtin() {
	cat data
}

getIPfromOS() {
	read -p "Nhập hệ điều hành: " hdh
	kq=$(awk -v os="$hdh" '$3 == os {print $2}' $data)
	if ! [[ -z "$kq" ]]; then
		echo "Các địa chỉ IP tìm được tương ứng: "
		echo "$kq"
	else
		echo "Không tìm thấy địa chỉ IP tương ứng"
	fi
}

getIPfromProtocol() {
	read -p "Nhập hệ giao thức: " gt
	kq=$(awk -v p="$gt" '$1 == p {print $2}' $data)
	if ! [[ -z "$kq" ]]; then
		echo "Các địa chỉ IP tìm được tương ứng: "
		echo "$kq"
	else
		echo "Không tìm thấy địa chỉ IP tương ứng"
	fi
}

countProtocol() {
    read -p "Nhập giao thức: " gt
    count=$(grep -c "^$gt" $data)
    echo "Số lần xuất hiện của giao thức '$gt': $count"
}

findOS() {
	mhdh=($(awk '{print $3}' $data | sort -u))
	echo ${mhdh[@]}
}

Info() {
	echo "Thống kê kết quả: "
	mhdh=($(findOS))
	touch thongke 2> /dev/null
	echo -n "" > thongke
	for hdh in ${mhdh[@]}; do
		count=$(grep -c "$hdh" $data)
		echo "$hdh $count" >> thongke
	done
	cat thongke
}

lc=0
while [[ lc -ne 7 ]]; do
	clear
	echo "MENU"
	echo "1. Nhập thông tin"
	echo "2. Xuất thông tin"
	echo "3. Tìm IP theo HĐH"
	echo "4. Tìm IP theo giao thức"
	echo "5. Đếm số lần kết nối của giao thức"
	echo "6. Thống kê"
	echo "7. Thoát"
	read -p "Lựa chọn: " lc
	case $lc in
		1) nhanthongtin ;;
		2) xuatthongtin ;;
		3) getIPfromOS ;;
		4) getIPfromProtocol ;;
		5) countProtocol ;;
		6) Info ;;
		7)
			echo "Hẹn gặp lại"
		;;
		*) 
            echo "Lựa chọn không hợp lệ"
        ;;
	esac
	read -p "Nhấn phím bất kỳ để tiếp tục" 
done














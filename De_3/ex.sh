#/bin/bash

filebs=$1
filerc=$2
ds_bien=$(awk '{print($1)}' $filebs)

update() {
	ds_bien=$(awk '{print($1)}' $filebs)
}

is_in_array() {
	local arr=$2
	local i
	for i in ${arr[@]}; do
		if [[ "$1" == "$i" ]]; then return 0; fi
	done
	return 1
}

nhap_bien_so() {
	local ten
	local dp
	read -p "Hãy nhập tên: " ten
	read -p "Hãy nhập địa phương: " dp
	local bien=$((RANDOM % 90000 + 10000))
	update
	while is_in_array $bien $ds_bien; do
		bien=$((RANDOM % 90000 + 10000))
	done
	echo "$bien $ten $dp" >> $filebs
	update
	echo "Thông tin mới $bien $ten $dp"
}

nhap_du_lieu() {
	local gio=$((RANDOM % 24))
	local phut=$((RANDOM % 60))
	local tg="$gio:$phut"
	local tocdo=$((RANDOM % 101 + 20))
	read -p "Hãy nhập biển số xe" local bien
	if ! is_in_array $bien $ds_bien; then
		echo "Biển số xe không tồn tại"
		return 1
	else
		echo "$bien $tg $tocdo" >> $filerc
	fi
}

xuat_tt() {
	echo "Thông tin xe:"
	cat $filebs
}

xuat_dl() {
	echo "Dữ liệu:"
	cat $filerc
}

trxuat_vp() {
	local i
	local bvp=$(awk '$3 > 60 {print $1}' $filerc)
	for i in ${bvp[@]}; do
		p1=$(awk -v b=$i '$1 == b {printf "%-25s %-10s %-10s ", $2, $1, $3}' $filebs)
		p2=$(awk -v b=$i '$1 == b {printf "%-10s %-10s" ,$2 , $3}' $filerc)
		echo "$p1 $p2"
	done
}

luu_vp() {
	echo $(trxuat_vp) >> vipham.txt
}

ktravp() {
	read -p "Nhập tên người muốn kiểm tra: " name
	rslt=$(grep -l "^$name" vipham.txt)
	if [[ -z $rslt ]]; then
		echo "Không tìm thấy vi phạm của $name"
	else
		cat $rslt
	fi
}

dem_vp() {
	read -p "Nhập địa phương cần kiểm tra: " dp
	rs=$(awk -v dph=$dp 'BEGIN {count=0} $3 == dph {count++} END {print count}' vipham.txt)
	echo "Địa phương '$dp' ghi nhận $rs vi phạm"
}

menu() {
	clear
	echo "Chương trình quản lý vi phạm giao thông"
	echo "Hãy lựa chọn các thao tác"
	echo "1. Nhập thông tin xe."
	echo "2. Nhập thông tin dữ liệu xe di chuyển"
	echo "3. Xuất thông tin danh sách biển số xe"
	echo "4. Xuất thông tin dữ liệu xe di chuyển"
	echo "5. Trích xuất thông tin xe vi phạm"
	echo "6. Lưu thông tin vi phạm"
	echo "7. Hiển thi tên người vi phạm"
	echo "8. Kiểm tra vi phạm"
	echo "9. Thoát"
	echo ""
	read -p "Chọn: " slct
	echo ""
	case $slct in
		1) nhap_bien_so ;;
		2) nhap_du_lieu ;;
		3) xuat_tt ;;
		4) xuat_dl ;;
		5)
			echo "Trích xuất vi phạm"
			trxuat_vp
		;;
		6) luu_vp ;;
		7) ktravp ;;
		8) dem_vp ;;
		9)
			echo "Hẹn gặp lại sau"
			return 0
		;;
		*)
			echo "Vui lòng chọn 1 lựa chọn hợp lệ!!!"
		;;
	esac
	echo ""
	read -p "Nhấn ENTER để tiếp tục: "
	return 1
}

while ! menu;do :;done














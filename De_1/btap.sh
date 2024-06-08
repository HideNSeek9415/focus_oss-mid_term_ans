#/bin/bash

fin=$1
flog=$2

xevao() {
    read -p "Nhập biển số xe: " bsx
    if grep -q "^$bsx" $fin; then
        echo "Xe đang ở trong bãi"
    else
        tg=$(date +"%a %B %-d %H:%M:%S %Y")
        echo "$bsx $tg" >> $fin
        echo "IN $bsx $tg" >> $flog
        echo "Xe $bsx vào bãi tại thời điểm: $tg"
    fi
}

demxe() {
    echo -n "Số lượng xe trong bãi: "
    cat $fin | wc -l
}

lsvaora() {
    read -p "Nhập biển số xe: " bsx
    kq=$(grep "$bsx" "$flog")
    if [[ -z "$kq" ]]; then
        echo "Xe chưa từng vào bãi"
    else 
        echo "Lich sử vào ra"
        echo "$kq"
    fi
}

xera() {
    read -p "Nhập biển số xe: " bsx
    tt=$(grep -l "^$bsx" $fin)
    if [[ -z $tt ]]; then
        echo "Xe không ở trong bãi"
    else
        tgr=$(date +"%a %B %-d %H:%M:%S %Y")
        IFS=' ' read -r -a tgv <<< $(grep "^$bsx" $fin)
        tgv=${tgv[@]:1}
        sed -i "/$bsx/d" $fin
        echo "OUT $bsx $tgr" >> $flog
        echo "__ XE : $bsx"
        echo "__ THỜI ĐIỂM VÀO: $tgv"
        echo "__ THỜI ĐIỂM RA : $tgr"
    fi
}

thongke() {
    read -p "Nhập ngày (1-31): " ng
    read -p "Nhập tháng (Jan-Dec): " th
    read -p "Nhập năm (2024): " n
    echo "______ Thống kê xe vào và ra ______"
    echo "Thống kê xe vào: "
    awk -v d=$ng -v m=$th -v y=$n '$1 == "IN" && $4 == m && $5 == d && $7 == y {printf("  %s\n", $0)}' $flog
    echo "Thống kê xe ra: "
    awk -v d=$ng -v m=$th -v y=$n '$1 == "OUT" && $4 == m && $5 == d && $7 == y {printf("  %s\n", $0)}' $flog
}

menu() {
    local lc=0
    while [[ true ]]; do
        clear
        echo "Hệ thống quản lý xe máy."
        echo "Hãy thực hiện lựa chọn:"
        echo "1. Nhập thông tin xe vào bãi."
        echo "2. Đếm số lượng xe trong bãi."
        echo "3. Dò tìm lịch sử xe ra vào bãi."
        echo "4. Nhập thông tin xe ra khỏi bãi."
        echo "5. Kiểm tra thông tin xe ra vào tại một thời điểm."
        echo "6. Thoát."
        read -p "Lựa chọn của bạn: " lc
        echo ""
        case $lc in
            1) xevao ;;
            2) demxe ;;
            3) lsvaora ;;
            4) xera ;;
            5) thongke ;;
            6)
                echo "Chào tạm biệt và hẹn ngày tái ngộ"
                return 0
            ;;
            *) echo "Vui lòng chọn một lựa chọn hợp lệ!!!" ;;
        esac
        echo ""
		read -p "Nhấn ENTER để tiếp tục"
    done
}

menu

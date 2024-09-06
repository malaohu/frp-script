#!/bin/bash

services=($(ls *.service 2>/dev/null))

if [ ${#services[@]} -eq 0 ]; then
    echo "当前目录下没有 .service 文件。"
    exit 1
fi

echo "请选择要复制到 /usr/lib/systemd/system/ 的服务文件:"
for i in "${!services[@]}"; do
    echo "$((i+1)). ${services[$i]}"
done

read -p "请输入要复制的文件编号(用逗号分隔多个选择): " choices

IFS=',' read -r -a selected_indices <<< "$choices"

for index in "${selected_indices[@]}"; do
    if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -ge 1 ] && [ "$index" -le "${#services[@]}" ]; then
        service_file="${services[$((index-1))]}"
        
        echo "正在复制 $service_file 到 /usr/lib/systemd/system/ ..."
        sudo cp "$service_file" /usr/lib/systemd/system/
    else
        echo "无效的选择: $index"
    fi
done

systemctl daemon-reload

echo "操作完成。"


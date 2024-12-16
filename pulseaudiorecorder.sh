#!/bin/bash
#https://www.gnu.org/licenses/gpl-3.0.txt
sources=$(pactl list sources short | awk '{print $2}')
options=()
while IFS= read -r source; do
    options+=("$source" "$source")
done <<< "$sources"
options+=("grabar_mezcla" "Grabar Mezcla")
selected_sources=$(zenity --list --checklist \
    --title="Seleccionar Fuentes de Audio" \
    --column="Seleccionar" \
    --column="Fuente" \
    "${options[@]}" \
    --height=400 \
    --width=300 \
    --ok-label="Iniciar Grabación")

if [ $? -eq 0 ]; then
    if [ -z "$selected_sources" ]; then
        zenity --error --text="Debes seleccionar al menos una fuente."
        exit 1
    fi
	echo ${selected_sources[0]}
    IFS='|' read -r -a sources_array <<< "$selected_sources"
    record_mix=false
    loopback_ids=()
    for source in "${sources_array[@]}"; do
        if [[ "$source" == "Grabar Mezcla" ]]; then
			echo "GRABAR MEZCLA"
            record_mix=true
            continue
        fi
    done
    if $record_mix; then
		echo "GRABAR MEZCLADO"
        sink_name="null_sink_$(date +%Y%m%d_%H%M%S)"
        pactl load-module module-null-sink sink_name="$sink_name"
        echo "Null sink creado: $sink_name"
        for source in "${sources_array[@]}"; do
            if [[ "$source" != "Grabar Mezcla" ]]; then
				echo "loopback para " $source
                loopback_id=$(pactl load-module module-loopback source="$source" sink="$sink_name")
                loopback_ids+=("$loopback_id")
            fi
        done
        output_file="grabacion_$(date +%Y%m%d_%H%M%S).wav"
        parec --device="$sink_name.monitor" --file-format=wav "$output_file" &
        pid=$!
    else
        output_file="grabacion_$(date +%Y%m%d_%H%M%S).wav"
        for source in "${sources_array[@]}"; do
            if [[ "$source" != "grabar_mezcla" ]]; then
                parec --device="$source" --file-format=wav "$output_file" &
                pid=$!
            fi
        done
    fi
    echo "Grabando audio de las fuentes seleccionadas. PID: $pid"
    echo "Presiona CTRL+C para detener la grabación."
    trap "kill $pid; for id in \"\${loopback_ids[@]}\"; do pactl unload-module \$id; done; if [ -n \"\$sink_name\" ]; then pactl unload-module module-null-sink; fi; echo 'Grabación detenida.'; exit" SIGINT
    wait $pid
    if $record_mix; then
        for id in "${loopback_ids[@]}"; do
            pactl unload-module "$id"
        done
        pactl unload-module module-null-sink
        echo "Null sink y loopbacks destruidos."
    fi
else
    echo "No se seleccionaron fuentes."
fi
pkill -f parec

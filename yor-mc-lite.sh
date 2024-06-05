#!/bin/bash

# https://github.com/soulhotel

yellow='\033[1;33m'
red='\033[1;31m'
green='\033[1;32m'
nocolor='\033[0m'

main_menu() {
    while true; do
        clear
        echo -n -e "
             Media Conversion Tool
             
  Please input a Gif or Video, then you can customize the output.

  ${green}Tip: You can also DRAG & DROP the file right into the terminal!${nocolor}

  Input file path: "
        read input_path
        

        # allows drag and drop functionality when reading path
        input_path="${input_path%\"}"
        input_path="${input_path#\"}"
        input_path=$(echo "$input_path" | tr -d "'")
        if [[ ! -f "$input_path" ]]; then
            echo -e "${red}File does not exist. Please try again.${nocolor}"
            continue
        fi

        input_file=$(basename "$input_path")
        extension="${input_file##*.}"

        if [[ "$extension" =~ ^(mp4|mkv|webm|webp|gif)$ ]]; then
            if [[ "$extension" == "gif" ]]; then
                gif_menu
            else
                video_menu
            fi
        else
            echo -e "${red}Please input either mp4, mkv, webm, webp, or gif${nocolor}"
            continue
        fi
    done
}

video_menu() {
    while true; do
        clear
        echo -n "
             Media Conversion Tool
             
        What would you like to do to \"$input_file\" 

        1. Video to gif
        2. Video to mkv
        3. Video to mp4
        4. Video to webm (video)
        5. Video to webp (animated pic)
        6. Don't convert, just format
        7. Main Menu
        8. Exit

        Make your pick (1 - 8): "
        read video_choice

        case $video_choice in
            1) convert_choice="Video to gif"; convert_extension="gif"; options_menu ;;
            2) convert_choice="Video to mkv"; convert_extension="mkv"; options_menu ;;
            3) convert_choice="Video to mp4"; convert_extension="mp4"; options_menu ;;
            4) convert_choice="Video to webm"; convert_extension="webm"; options_menu ;;
            5) convert_choice="Video to webp"; convert_extension="webp"; options_menu ;;
            6) convert_extension="$extension"; options_menu ;;
            7) main_menu ;;
            8) exit 0 ;;
            *) echo -e "${red}Invalid option. Please try again.${nocolor}" ;;
        esac
    done
}

gif_menu() {
    while true; do
        clear
        echo -n "
             Media Conversion Tool
             
        What would you like to do to \"$input_file\" 

        1. Gif to mkv
        2. Gif to mp4
        3. Gif to webm
        4. Gif to webp
        5. Don't convert, just format
        6. Main Menu
        7. Exit

        Make your pick (1 - 7): "
        read gif_choice

        case $gif_choice in
            1) convert_choice="Gif to mkv"; convert_extension="mkv"; options_menu ;;
            2) convert_choice="Gif to mp4"; convert_extension="mp4"; options_menu ;;
            3) convert_choice="Gif to webm"; convert_extension="webm"; options_menu ;;
            4) convert_choice="Gif to webp"; convert_extension="webp"; options_menu ;;
            5) convert_extension="$extension"; options_menu ;;
            6) main_menu ;;
            7) exit 0 ;;
            *) echo -e "${red}Invalid option. Please try again.${nocolor}" ;;
        esac
    done
}

options_menu() {
    local selected_options=()
    local vf_flags=""
    while true; do
        clear
        echo -n -e "
             Media Conversion Tool
             
        You've chosen \"$convert_choice\" for \"$input_file\"

        Now what would you like to do to it?

        1. True to size          6. Rotate 90 clockwise                
        2. 50 percent size       7. Rotate 90 counter clockwise
        3. 75 percent size       8. Flip upside down
        4. Square format         9. Back to Main Menu
        5. High Resolution      10. Exit

        ${green}Tip: You can make multiple selections!${nocolor}

        You've selected:${yellow} ${selected_options[*]} ${nocolor}

        Make a selection or press ENTER when done: "
        read option_choice

        case $option_choice in
            1) selected_options+=("1. True to size"); vf_flags+="scale=iw:ih," ;;
            2) selected_options+=("2. 50 percent size"); vf_flags+="scale=iw/2:ih/2," ;;
            3) selected_options+=("3. 75 percent size"); vf_flags+="scale=iw*0.75:ih*0.75," ;;
            4) selected_options+=("4. Square format"); vf_flags+="scale=500:500," ;;
            5) selected_options+=("5. High Resolution"); vf_flags+="flags=lanczos," ;;
            6) selected_options+=("6. Rotate 90 clockwise"); vf_flags+="transpose=1," ;;
            7) selected_options+=("7. Rotate 90 counter clockwise"); vf_flags+="transpose=2," ;;
            8) selected_options+=("8. Flip upside down"); vf_flags+="vflip," ;;
            9) main_menu ;;
            10) exit 0 ;;
            "") break ;;
            *) echo -e "${red}Invalid option. Please try again.${nocolor}" ;;
        esac
    done

    vf_flags="${vf_flags%,}"

    convert_file
}

format_only() {
    convert_choice="No conversion, just format"
    options_menu
}

convert_file() {
    output_folder=$(dirname "$input_path")
    filename="${input_file%.*}" # Extract the file name without extension
    output_file="$output_folder/$filename-mc.$convert_extension" # Prepend "mc-" to the output file name
    vf_flags="${vf_flags%,}"
    
    if [[ "$convert_choice" == "Video to gif" ]]; then
        vf_flags="fps=30,$vf_flags"
    fi

    if [[ -z "$vf_flags" ]]; then
        if [[ "$input_file" == *.gif && "$convert_extension" != "gif" ]]; then
            # Handle GIF to video conversion with palette generation
            palette="$output_folder/palette.png"
            ffmpeg -i "$input_path" -vf "palettegen" -y "$palette"
            ffmpeg -i "$input_path" -i "$palette" -lavfi "paletteuse" "$output_file"
        else
            ffmpeg -i "$input_path" "$output_file"
        fi
    else
        if [[ "$input_file" == *.gif && "$convert_extension" != "gif" ]]; then
            # Handle GIF to video conversion with palette generation and vf_flags
            palette="$output_folder/palette.png"
            ffmpeg -i "$input_path" -vf "palettegen" -y "$palette"
            ffmpeg -i "$input_path" -i "$palette" -lavfi "$vf_flags,paletteuse" "$output_file"
        else
            ffmpeg -i "$input_path" -vf "$vf_flags" "$output_file"
        fi
    fi

    echo -e "\n${yellow}Task complete: Review the FFMPEG log for any questions. Want to do another?${nocolor}"
    echo -e "\nPress ENTER to return to the Main Menu"
    read -r another

    if [[ -z "$another" ]]; then
        main_menu
    else
        exit 0
    fi
}


main_menu

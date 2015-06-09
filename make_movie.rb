def create_movie_from_frames
  system("ffmpeg -r 1/5 -pattern_type glob -i '*.png' -c:v libx264 out.mp4")
end

create_movie_from_frames
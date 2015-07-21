export LC_TIME=en_US.UTF-8
cd blog
rm posts.html
python generate_posts_list.py
cd ..
make


set breakpoint pending on
# gcc -g3 -fno-omit-frame-pointer -fsanitize=address -O1
break __asan_report_error

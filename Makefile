all:
	love ./

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2023-fall-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2023-fall-game-jam/"
	python3 -m http.server

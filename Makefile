all:
	love ./
	# rm -rf makelove-build
	# makelove

desktop:
	love ./

serve:
	$(MAKE) all
	unzip -o "makelove-build/lovejs/2023-fall-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2023-fall-game-jam/"
	python3 -m http.server

publish:
	$(MAKE) all
	unzip -o "makelove-build/lovejs/2023-fall-game-jam-lovejs" -d ~/dev/mikepurdy.dev/static/ 

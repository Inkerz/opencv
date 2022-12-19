all:
	@docker build -t opencv .
	@docker run -v "${PWD}/:/artifacts" opencv


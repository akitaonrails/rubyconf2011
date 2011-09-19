clean:
	$(RM) -rf output
install:
	bundle exec nanoc3 compile
	

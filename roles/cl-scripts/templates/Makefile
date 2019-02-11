NAME=meus-papiros
BINARY={{ home }}/bin/$(NAME)
SCRIPT={{ home }}/common-lisp/$(NAME)
CL=cl-launch

.PHONY: all $(NAME) clean

all: $(NAME)

$(NAME):
	@$(CL) --output $(NAME) --dump ! --lisp sbcl --quicklisp --system $(NAME) --dispatch-system $(NAME)/main

install: $(NAME)
	@ln -sf $(SCRIPT) $(BINARY)
	@$(SCRIPT) symlink $(NAME)

clean:
	@rm -f $(NAME)

uninstall:
	@$(SCRIPT) un-symlink
	@rm -f $(BINARY)

# Define the root directory of the project
MIDAZ_STACK_ROOT := $(shell pwd)

# Define component directories
MIDAZ_DIR := $(MIDAZ_STACK_ROOT)/midaz
MIDAZ_CONSOLE_DIR := $(MIDAZ_STACK_ROOT)/midaz-console

# Define a list of all component directories for easier iteration
COMPONENTS := $(MIDAZ_DIR) $(MIDAZ_CONSOLE_DIR)

# Include shared color definitions and utility functions
include $(MIDAZ_STACK_ROOT)/utils/makefile_colors.mk
include $(MIDAZ_STACK_ROOT)/utils/makefile_utils.mk

# Shell utility functions
define print_logo
	@cat $(MIDAZ_STACK_ROOT)/utils/logo.txt
endef

# Check if a command exists
define check_command
	@if ! command -v $(1) >/dev/null 2>&1; then \
		echo "$(RED)Error: $(1) is not installed$(NC)"; \
		echo "$(MAGENTA)To install: $(2)$(NC)"; \
		exit 1; \
	fi
endef

# Create midaz environment file
define check_env_files
	echo "$(YELLOW)Setting up midaz environment file...$(NC)"; \
	cd $(MIDAZ_DIR) && make set-env;
endef

# Core Commands
.PHONY: help
help:
	$(call print_logo)
	@echo ""
	@echo ""
	@echo "$(BOLD)Midaz Stack Project Management Commands$(NC)"
	@echo ""
	@echo ""
	@echo "$(BOLD)Core Commands:$(NC)"
	@echo "  make help                        - Display this help message"
	@echo "  make up                          - Start all services"
	@echo "  make down                        - Stop all services"
	@echo "  make stop                        - Stop all services (alias for down)"
	@echo "  make restart                     - Restart all services"
	@echo ""
	@echo ""
	@echo "$(BOLD)Setup Commands:$(NC)"
	@echo "  make build                       - Build all project services"
	@echo "  make clean                       - Clean artifacts and Docker resources"
	@echo ""
	@echo ""
	@echo "$(BOLD)Help Commands:$(NC)"
	@echo "  make midaz-help                  - Show available midaz commands"
	@echo "  make midaz-console-help          - Show available midaz-console commands"
	@echo ""
	@echo ""

# Core Commands
.PHONY: up
up:
	@echo "$(BLUE)Starting all services...$(NC)"
	$(call title1,"STARTING ALL SERVICES")
	$(call check_command,docker,"Install Docker from https://docs.docker.com/get-docker/")
	$(call check_env_files)
	@echo "$(BLUE)Setting up and starting Midaz services...$(NC)"
	@cd $(MIDAZ_DIR) && make all-services COMMAND="up"
	@echo "$(BLUE)Setting up and starting Midaz Console...$(NC)"
	@cd $(MIDAZ_CONSOLE_DIR) && npm update && npm run docker-up
	@echo "$(GREEN)$(BOLD)[ok]$(NC) All services started successfully$(GREEN) ✔️$(NC)"

.PHONY: stop
stop:
	@echo "$(BLUE)Stopping all services...$(NC)"
	$(call title1,"STOPPING ALL SERVICES")
	$(call check_command,docker,"Install Docker from https://docs.docker.com/get-docker/")
	@echo "$(BLUE)Stopping Midaz services...$(NC)"
	@cd $(MIDAZ_DIR) && make all-services COMMAND="stop"
	@echo "$(BLUE)Stopping Midaz Console...$(NC)"
	@cd $(MIDAZ_CONSOLE_DIR) && $(DOCKER_CMD) stop
	@echo "$(GREEN)$(BOLD)[ok]$(NC) All services stopped successfully$(GREEN) ✔️$(NC)"

.PHONY: down
down:
	@echo "$(BLUE)Getting all services down...$(NC)"
	$(call title1,"DOWNING ALL SERVICES")
	$(call check_command,docker,"Install Docker from https://docs.docker.com/get-docker/")
	@echo "$(BLUE)Downing Midaz services...$(NC)"
	@cd $(MIDAZ_DIR) && make all-services COMMAND="down"
	@echo "$(BLUE)Downing Midaz Console...$(NC)"
	@cd $(MIDAZ_CONSOLE_DIR) && $(DOCKER_CMD) down
	@echo "$(GREEN)$(BOLD)[ok]$(NC) All services downed successfully$(GREEN) ✔️$(NC)"

.PHONY: restart
restart:
	@echo "$(BLUE)Restarting all services...$(NC)"
	$(call title1,"RESTARTING ALL SERVICES")
	$(call check_command,docker,"Install Docker from https://docs.docker.com/get-docker/")
	$(call check_env_files)
	@containers_exist=true; \
	for dir in $(COMPONENTS); do \
		if [ "$$dir" = "$(MIDAZ_DIR)" ]; then \
			for subdir in $$(find $$dir/components -maxdepth 1 -type d | grep -v "^$$dir/components$$"); do \
				service_name=$$(basename $$subdir); \
				if ! docker ps -a --format '{{.Names}}' | grep -q "$$service_name"; then \
					containers_exist=false; \
					break; \
				fi; \
			done; \
		elif [ "$$dir" = "$(MIDAZ_CONSOLE_DIR)" ]; then \
			if ! docker ps -a --format '{{.Names}}' | grep -q "console"; then \
				containers_exist=false; \
			fi; \
		fi; \
	done; \
	if [ "$$containers_exist" = "false" ]; then \
		echo "$(YELLOW)Some containers don't exist. Running 'up' to build and start them...$(NC)"; \
		$(MAKE) up; \
	else \
		echo "$(BLUE)Restarting Midaz services...$(NC)"; \
		cd $(MIDAZ_DIR) && make all-services COMMAND="restart"; \
		echo "$(BLUE)Restarting Midaz Console...$(NC)"; \
		cd $(MIDAZ_CONSOLE_DIR) && $(DOCKER_CMD) restart; \
		echo "$(GREEN)$(BOLD)[ok]$(NC) All services restarted successfully$(GREEN) ✔️$(NC)"; \
	fi

.PHONY: clean
clean:
	@echo "$(BLUE)Cleaning project artifacts and Docker resources...$(NC)"
	$(call title1,"CLEANING UP RESOURCES")
	@echo "$(BLUE)Downing all services first...$(NC)"
	$(MAKE) down
	@echo "$(YELLOW)Pruning Docker system...$(NC)"
	@cd $(MIDAZ_DIR) && docker system prune -f && docker volume prune -f -a
	@cd $(MIDAZ_CONSOLE_DIR) && docker system prune -f && docker volume prune -f -a
	@echo "$(GREEN)$(BOLD)[ok]$(NC) All artifacts cleaned successfully$(GREEN) ✔️$(NC)"

# Help Commands
.PHONY: midaz-help
midaz-help:
	@echo "$(BLUE)Available Midaz commands:$(NC)"
	$(call title1,"MIDAZ COMMANDS")
	@echo "$(BOLD)To run a command:$(NC) cd $(MIDAZ_DIR) && make <command>"
	@echo ""
	@echo "$(BOLD)Core Commands:$(NC)"
	@echo "  help                        - Display Midaz help message"
	@echo "  test                        - Run tests on all Midaz projects"
	@echo "  cover                       - Run test coverage"
	@echo ""
	@echo "$(BOLD)Code Quality Commands:$(NC)"
	@echo "  lint                        - Run golangci-lint and performance checks"
	@echo "  format                      - Format Go code using gofmt"
	@echo "  check-logs                  - Verify error logging in usecases"
	@echo "  check-tests                 - Verify test coverage for components"
	@echo "  sec                         - Run security checks using gosec"
	@echo ""
	@echo "$(BOLD)Service Commands:$(NC)"
	@echo "  up                          - Start all Midaz services"
	@echo "  down                        - Stop all Midaz services"
	@echo "  start                       - Start all Midaz containers"
	@echo "  stop                        - Stop all Midaz containers"
	@echo "  restart                     - Restart all Midaz containers"
	@echo "  rebuild-up                  - Rebuild and restart all Midaz services"
	@echo ""

.PHONY: midaz-console-help
midaz-console-help:
	@echo "$(BLUE)Available Midaz Console commands:$(NC)"
	$(call title1,"MIDAZ CONSOLE COMMANDS")
	@echo "$(BOLD)To run a command:$(NC) cd $(MIDAZ_CONSOLE_DIR) && npm run <command>"
	@echo ""
	@echo "$(BOLD)Development Commands:$(NC)"
	@echo "  dev                         - Start development server"
	@echo "  build                       - Build the application"
	@echo "  start                       - Start the application"
	@echo "  lint                        - Run linter and fix issues"
	@echo "  format                      - Format code with Prettier"
	@echo ""
	@echo "$(BOLD)Testing Commands:$(NC)"
	@echo "  test                        - Run Jest tests"
	@echo "  test:e2e                    - Run Playwright end-to-end tests"
	@echo ""
	@echo "$(BOLD)Docker Commands:$(NC)"
	@echo "  docker-up                   - Start Docker container"
	@echo "  set-env                     - Copy .env.example to .env"
	@echo ""
	@echo "$(BOLD)Storybook Commands:$(NC)"
	@echo "  storybook                   - Start Storybook development server"
	@echo "  build-storybook             - Build Storybook static site"
	@echo ""
	@echo "$(BOLD)i18n Commands:$(NC)"
	@echo "  extract:i18n                - Extract i18n messages"
	@echo "  compile:i18n                - Compile i18n messages"
	@echo "  i18n                        - Run both extract and compile i18n"
	@echo ""
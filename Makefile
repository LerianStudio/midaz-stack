.PHONY: help up stop remove

help:
	@echo "Management commands"
	@echo ""
	@echo "Usage:"
	@echo "  ## Root Commands"
	@echo "    make up                                  Run all projects services."
	@echo "    make down                                Down all projects services."
	@echo ""


up:
	@echo "Initiating all services..."
	@set -e
	@cd midaz && make set-env && make all-services COMMAND="up"
	@cd midaz-console && npm update && npm run docker-compose
	@echo "Services initiated successfully"

stop:
	@echo "Stopping services..."
	@set -e
	@cd midaz && make all-services COMMAND="stop"
	@cd midaz-console && docker-compose stop
	@echo "All services stopped."

remove:
	@echo "Shutting down and remove services..."
	@set -e
	@cd midaz && make all-services COMMAND="stop"
	@cd midaz-console && docker-compose stop
	@docker system prune -a -f
	@docker volume prune -a -f
	@echo "All services stopped and cleaned up."
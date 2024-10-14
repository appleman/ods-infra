# Define variables
RELEASE_NAME=kafka-operator-0.43
CHART_NAME=.
NAMESPACE=op-kafka-operator
VALUES_FILES=values.yaml -f custom-values.yaml

# Define the default target
.PHONY: all
all: install

# Install the Helm chart
.PHONY: install
install:
	@echo "Installing Helm chart..."
	helm install $(RELEASE_NAME) $(CHART_NAME) \
		-f $(VALUES_FILES) \
		--namespace $(NAMESPACE) --create-namespace

# Upgrade the Helm chart
.PHONY: upgrade
upgrade:
	@echo "Upgrading Helm chart..."
	helm upgrade $(RELEASE_NAME) $(CHART_NAME) \
		-f $(VALUES_FILES) \
		--namespace $(NAMESPACE)

# Uninstall the Helm release
.PHONY: uninstall
uninstall:
	@echo "Uninstalling Helm release..."
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

# List the Helm releases
.PHONY: list
list:
	@echo "Listing Helm releases..."
	helm list --namespace $(NAMESPACE)

# Dry-run for install
.PHONY: dry-run-install
dry-run-install:
	@echo "Dry-run installing Helm chart..."
	helm install $(RELEASE_NAME) $(CHART_NAME) \
		-f $(VALUES_FILES) \
		--namespace $(NAMESPACE) --dry-run --debug

# Dry-run for upgrade
.PHONY: dry-run-upgrade
dry-run-upgrade:
	@echo "Dry-run upgrading Helm chart..."
	helm upgrade $(RELEASE_NAME) $(CHART_NAME) \
		-f $(VALUES_FILES) \
		--namespace $(NAMESPACE) --dry-run --debug



# Print usage information
.PHONY: help
help:
	@echo "Makefile for managing Helm charts"
	@echo ""
	@echo "Usage:"
	@echo "  make install       Install the Helm chart"
	@echo "  make upgrade       Upgrade the Helm chart"
	@echo "  make uninstall     Uninstall the Helm release"
	@echo "  make list          List Helm releases"
	@echo "  make help          Show this help message"
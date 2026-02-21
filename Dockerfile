# Use Node.js 20 as the base image
# This means our container will run in a Node.js 20 environment
# Think of this like installing Node 20 on a fresh Linux machine
FROM node:20

# Set the working directory inside the container
# This tells Docker: "From now on, run all commands inside /app"
# It also creates the folder automatically if it does not exist
#
# Why important?
# - All files we copy will go here (unless we specify another path)
# - npm install will run inside this folder
# - Our project will live here
#
# Without WORKDIR, Docker would use root (/) which is messy
WORKDIR /app

# Copy only package.json first
# First "." = source (your local project folder)
# Second "." = destination inside container (current WORKDIR => /app)
#
# Why copy package.json first?
# Docker caching optimization:
# If dependencies don't change, Docker won't reinstall npm packages
COPY package.json .

# Install dependencies inside the container
# Runs inside /app because of WORKDIR
# Equivalent to:
# cd /app && npm install
RUN npm install

# Copy the rest of the project files into the container
#
# First "." = copy everything from current local folder
# Second "." = paste into current container folder (/app)
#
# So this means:
# Local project → /app inside container
COPY . .

# Expose port 5000
# This is just documentation for Docker
# It tells: "This app runs on port 5000 inside container"
# To access from outside we still need -p mapping
EXPOSE 5000

# Default command when container starts
# Runs: npm run dev
# Example: starts Express dev server or Vite or Next.js dev mode
CMD ["npm", "run", "dev"]
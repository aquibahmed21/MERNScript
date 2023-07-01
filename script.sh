#!/bin/bash

# Find and kill the process running on port 3000
lsof -ti :3000 | xargs kill

# Find and kill the process running on port 5000
lsof -ti :5000 | xargs kill

rm -rf react-express-mongodb

# Check the operating system
# os=$(uname)

# Step 1: Create a new directory for your project
mkdir react-express-mongodb
cd react-express-mongodb

# Step 3: Set up the backend (Express.js)
mkdir backend
cd backend
npm init -y
npm install dotenv typescript ts-node express mongoose request jsonwebtoken express-validator crypto-js @types/cors bcryptjs @types/express @types/mongoose
npm install --save-dev nodemon concurrently dotenv

# Initialize TypeScript in the backend
npx tsc --init

touch .getignore
touch .env

# if [ "$os" == "Darwin" ]; then
	# sed -i '' 's/"author": "",/ "author": "Aquib Ahmed",/' package.json
	# sed -i '' 's/"main": "index.js",/ "main": "server.js",/' package.json
	# sed -i '' 's/"test": "echo \\"Error: no test specified\\" && exit 1"/ "init": "ts-node init_server.ts",/' package.json
	# sed -i '' 's/"init": "ts-node init_server.ts",/ "init": "ts-node init_server.ts",\
	# 		"start": "nodemon --exec ts-node init_server.ts"/' package.json
# elif [ "$os" == "Linux" ]; then
	sed -i 's/"author": "",/ "author": "Aquib Ahmed",/' package.json
	sed -i 's/"main": "index.js",/ "main": "server.js",/' package.json
	sed -i 's/"scripts": {/"scripts": {\n    "init": "ts-node init_server.ts",\n    "start": "nodemon --exec ts-node init_server.ts",/' package.json
# fi

# Step 4: Create the server file (index.ts) in the backend directory
touch init_server.ts

echo 'import Server from "./typescript/server";
import dotenv from "dotenv";

dotenv.config();
const PORT: number = Number(process.env.PORT) || 5000;

const server = new Server();
server.start(PORT);' > init_server.ts

mkdir typescript
touch typescript/server.ts

echo '
import express, { Request, Response } from "express";
import bodyParser from "body-parser";
import cors from "cors";

// Create a class to represent the app
class Server
{
	// Create a private field to store the Express app instance
	private app: express.Application;

	// Create a constructor to initialize the app
	constructor ()
	{
		this.app = express();
		this.setupRoutes();
		this.configureMiddleware();
	}

	private configureMiddleware (): void
	{
    // this.app.use(cors());
    this.app.use(bodyParser.json());
  }

	// Create a method to set up the routes for the app
	private setupRoutes (): void
	{
		// Define a root route handler function
		const rootRoute = (req: Request, res: Response): void =>
		{
			res.send("Welcome to the root route!");
		};

		const otherRoute = (req: Request, res: Response): void =>
		{
			const page = req.params.path;

			switch (page)
			{
				case "about":
					res.status(200).send("This is the about page.");
					break;
				case "contact":
					res.status(200).send("This is the contact page.");
					break;
				case "api":
					res.status(200).send({id: 1, name: "Aquib"});
					break;
				default:
					res.status(404).send("404 Not Found");
					break;
			}
		};

		// Use the app instance to set up the root route
		this.app.get("/", rootRoute);
		this.app.get("/:path", otherRoute);
	}

	// Create a method to start the server
	public start (port: number): void
	{
		this.app.listen(port, () =>
		{
			console.log(`Server listening on port ${ port }`);
		});
	}
}

export default Server;' > typescript/server.ts


# Step 2: Set up the frontend (React)
cd ..
npx create-react-app frontend --template typescript

cd frontend

# Linux
sed -i 's/"private": true,/"private": true,\n  "proxy": "http:\/\/localhost:5000",/' package.json
sed -i 's/"author": "",/ "author": "Aquib Ahmed",/' package.json
sed -i 's/"start": "react-scripts start",/"start": "PORT=3000 react-scripts start",/' package.json

# mac
# sed -i '' -e '/"private": true/a\
#               "proxy": "http:\/\/localhost:5000",' package.json
# sed -i '' -e '/"private": true/a\
#               "author": "Aquib Ahmed",' package.json
# sed -i '' 's/"start": "react-scripts start",/"start": "PORT=3000 react-scripts start",/' package.json

rm src/logo.svg
rm src/App.css
rm src/App.tsx
rm src/App.test.tsx
rm src/react-app-env.d.ts
rm src/reportWebVitals.ts
rm src/setupTests.ts

# Modify the index.css
echo "* {
  padding: 0;
  margin: 0;
  font-family: inherit;
}

body {
  min-height: 100vh;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}" > src/index.css

# Preparing the pages directory
mkdir src/pages
mkdir src/pages/app
mkdir src/pages/images
mkdir src/pages/app/components

echo "import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './pages/app/App';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);" > src/index.tsx

# # prepare the app.tsx
touch src/pages/app/App.tsx
echo "import Home from './components/Home';

const App: React.FC = () =>
{
  return (
    <Home />
  );
};

export default App;" > src/pages/app/App.tsx

# # Preparing the Home Component
mkdir src/pages/app/components/Home
touch src/pages/app/components/Home.tsx
echo "import { useState, useEffect } from 'react';

const Home: React.FC = () =>
{
	const [ users, setUsers ] = useState<UserDetails>();

	const fetchUsers = async () =>
	{
		const response = await fetch('/api');
		const user = await response.json();
		setUsers(user);
	};

	useEffect(() =>
	{
		fetchUsers();
	}, []);

	return (
		<>
		  <span>I'm <strong >{ users?.name }</strong></span>
		</>
	);
};

interface UserDetails
{
	id: number;
	name: string;
}

export default Home;" > src/pages/app/components/Home.tsx

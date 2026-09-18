# CycleInsight

CycleInsight is a menstrual tracking and health analysis application that allows users to record their menstrual cycles, daily health information, and symptoms. The backend processes the collected data to provide cycle statistics, phase-based analysis, predictions, and personal insights.

The project is currently under development.

## About the Project

CycleInsight is designed to combine menstrual cycle tracking with data analysis. Users can record cycle dates, daily wellbeing information, and symptoms through the mobile application.

The backend is responsible for user authentication, data management, analysis, and providing the API used by the Flutter frontend.

The main goal of the project is to turn the user's recorded data into understandable statistics and insights rather than only storing cycle information.

## Features

- User registration and login
- JWT-based authentication
- Secure password hashing with bcrypt
- Menstrual cycle management
- Daily health log management
- Symptom tracking
- User-specific data access
- Cycle length and variability analysis
- Cycle regularity assessment
- Cycle trend analysis
- Bleeding analysis
- Wellbeing analysis
- Phase-based analysis
- Phase-based symptom analysis
- Cycle and ovulation date estimation
- Prediction confidence calculation
- Correlation analysis
- Personal insight generation
- Flutter frontend and FastAPI backend communication

## Backend / My Role

My main responsibility in this project is **backend development**.

I designed and implemented the backend using Python and FastAPI, including:

- REST API endpoints for users, cycles, daily logs, and symptoms
- Database models and relationships
- CRUD operations
- JWT authentication and authorization
- Password hashing with bcrypt
- Request and response validation with Pydantic
- Database interaction using SQLAlchemy
- PostgreSQL database integration
- Data preparation and analysis services
- Cycle, bleeding, wellbeing, symptom, and phase-based analysis
- Prediction and confidence calculation
- Personal insight generation
- Backend testing and error handling
- Frontend-backend API integration

The Flutter frontend is part of the project, but frontend development is not my primary responsibility.

## Technologies

### Backend

- Python
- FastAPI
- SQLAlchemy
- Pydantic
- PostgreSQL
- JWT
- bcrypt
- SciPy

### Frontend

- Flutter
- Dart

### Development

- Git
- GitHub

## Database

CycleInsight uses **PostgreSQL 17** for persistent data storage.

The main database tables are:

- `users` — user account information
- `cycles` — menstrual cycle records
- `daily_logs` — daily health and wellbeing records
- `symptom_types` — available symptom types
- `daily_log_symptoms` — relationship between daily logs and symptoms

Daily logs contain fields such as:

- bleeding level
- mood level
- pain level
- sleep quality
- stress level
- notes

Cycle length and duration are calculated during analysis rather than stored as separate database fields.

## Authentication

The backend uses JWT-based authentication.

Passwords are stored as hashes using bcrypt rather than plain text. Authenticated requests use a bearer token, and the authenticated user's ID is used to restrict access to their own data.

The authentication flow includes:

1. User registration
2. Password hashing
3. Login
4. JWT token generation
5. Bearer token authentication
6. Authenticated access to user-specific resources

## API

The backend provides endpoints for:

- User registration
- Login
- Current user (`/me`)
- Cycle CRUD operations
- Daily log CRUD operations
- Symptom management
- Symptom type retrieval
- Analysis results

The main analysis endpoint is:

```text
GET /analysis
```

The API is implemented with FastAPI and uses Pydantic schemas for request and response validation.

## Analysis

The analysis layer is separated into multiple modules to keep different types of calculations independent.

Current analysis components include:

- Cycle statistics
- Cycle regularity
- Cycle variability and range
- Cycle trends
- Bleeding analysis
- Wellbeing analysis
- Symptom frequency and occurrence
- Phase-based symptom distribution
- Phase-based wellbeing analysis
- Correlations between recorded variables
- Cycle and ovulation predictions
- Prediction confidence
- Insight generation

The project also includes automated tests for the analysis components and edge cases.

## Project Structure

```text
CycleInsight/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   ├── analysis/
│   │   │   ├── analysis_service.py
│   │   │   ├── cycle_analysis.py
│   │   │   ├── bleeding_analysis.py
│   │   │   ├── wellbeing_analysis.py
│   │   │   ├── symptom_analysis.py
│   │   │   ├── data_preparation.py
│   │   │   ├── correlation_analysis.py
│   │   │   ├── phase_analysis.py
│   │   │   ├── prediction_analysis.py
│   │   │   └── insight_generation.py
│   │   ├── core/
│   │   ├── crud/
│   │   ├── db/
│   │   ├── models/
│   │   └── schemas/
│   ├── tests/
│   └── ...
│
├── frontend/
│   └── lib/
│       ├── core/
│       ├── data/
│       ├── screens/
│       └── widgets/
│
└── README.md
```

## Getting Started

### Backend

Clone the repository:

```bash
git clone https://github.com/iremgoreci/CycleInsight.git
cd CycleInsight/backend
```

Create and activate a virtual environment:

**Windows PowerShell**

```powershell
python -m venv venv
.\venv\Scripts\activate
```

Install the backend dependencies:

```bash
pip install -r requirements.txt
```

Create a `.env` file and configure the required database and authentication settings.

Then start the FastAPI development server:

```bash
python -m uvicorn app.main:app --reload
```

The API can then be tested through the FastAPI Swagger interface.

### Frontend

The mobile application is built with Flutter.

From the frontend directory:

```bash
cd frontend
flutter pub get
flutter run
```

The backend should be running before using features that require API communication.

## Testing

The backend contains tests for the analysis modules and related services.

Tests can be run with:

```bash
pytest
```

The analysis test suite currently covers cycle analysis, prediction analysis, statistical analysis, bleeding and symptom analysis, phase analysis, data preparation, and analysis services.

## Project Status

CycleInsight is an ongoing personal project.

The core backend, database structure, authentication system, CRUD operations, analysis services, and Flutter application are implemented. The project is still being improved through testing, UI refinement, analysis improvements, and further development.

## License

This project is currently developed as a personal project.

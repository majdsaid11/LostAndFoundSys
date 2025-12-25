# LostAndFoundSys

LostAndFoundSys is a Java web application designed to manage lost and found items
within an organization or campus. The system allows users to report lost items,
view found items, and access role-based dashboards.

The project was built to practice core Java web development concepts using
Servlets, JSP, filters, and database connectivity.

---

## Features

- User authentication (login & signup)
- Role-based access (student / staff dashboards)
- Submit and view lost items
- Image handling for reported items
- Maintenance filter for request control
- Session management using Java Servlets

---

## Technologies Used

- Java (Servlets & Filters)
- JSP (JavaServer Pages)
- Apache Derby (Database)
- GlassFish Server
- NetBeans IDE
- HTML / CSS

---

## Project Structure

```
src/        → Java servlets, filters, and backend logic  
web/        → JSP pages (view layer / frontend)  
```
---

## Setup Instructions

1. Install **JDK** (Java 8 or Java 11 recommended)
2. Install **NetBeans IDE**
3. Configure **GlassFish Server** in NetBeans
4. Configure **Apache Derby** (Network Server)
5. Open the project in NetBeans
6. Deploy and run the application on GlassFish

> Note: Environment-specific configuration (JDK version, server setup,
> and database connection) is required before running the project.

---

## Database

- Apache Derby is used as the database
- Database connection logic is implemented in `DBConnection.java`
- Tables must be created before running the application

---

## Purpose of the Project

This project focuses on strengthening understanding of:
- Java web application architecture
- HTTP request/response handling
- Session management
- Backend–frontend integration
- Clean project structuring for version control

---

## Notes

This is an academic and learning-focused project intended to demonstrate
backend web development skills using Java EE technologies.

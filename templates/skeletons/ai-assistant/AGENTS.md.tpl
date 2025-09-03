# AGENTS.md

## Project Description

${{values.description}}

This project is a FastAPI-based AI assistant service that provides chat capabilities and interaction with artificial intelligence models.

## Setup Commands

- Install dependencies: `pip install -r requirements.txt`
- Start development server: `uvicorn src.main:app --reload --host 0.0.0.0 --port 8000`
- Run tests: `pytest`
- Format code: `black . && isort .`
- Check code quality: `flake8 .`

## Project Structure

- `src/main.py` - Main FastAPI application file
- `src/chat/` - Chat module and AI logic
- `src/models/` - Data models for requests/responses
- `src/services/` - AI API integration services
- `requirements.txt` - Project dependencies
- `.env.example` - Example environment variables
- `.devcontainer/` - Development container configuration

## Code Style

- Use Python 3.11+ with type hints
- Follow PEP 8 with Black as formatter
- Use isort to organize imports
- Include docstrings for AI functions
- Keep AI logic separated in specific modules
- Use Pydantic for chat model validation

## Script Integrations

### Development Commands

- `uvicorn src.main:app --reload` - Server with hot reload
- `pytest` - Run AI and endpoint tests
- `black .` - Format code
- `python -m src.chat.test` - Manual chat testing

### AI Service Integrations

This service can integrate with:
- OpenAI GPT models
- Azure OpenAI Service
- Anthropic Claude
- LangChain for complex workflows
- Vector databases for RAG

## Testing Instructions

### AI Testing
- Use mocks for AI APIs in unit tests
- Implement integration tests with rate limiting
- Verify chat response formats
- Test API error handling

### Endpoint Testing
```bash
# Health check test
curl http://localhost:8000/health

# Chat endpoint test
curl -X POST "http://localhost:8000/chat" \
     -H "Content-Type: application/json" \
     -d '{"message": "Hello, how can you help me?"}'

# Documentation test
curl http://localhost:8000/docs
```

### Manual AI Testing
```python
# Manual test script
from src.chat.service import ChatService

service = ChatService()
response = service.chat("Explain machine learning")
print(response)
```

## Development Configuration

1. Clone the repository
2. Create virtual environment: `python -m venv venv`
3. Activate environment: `source venv/bin/activate`
4. Install dependencies: `pip install -r requirements.txt`
5. Copy `.env.example` to `.env` and configure API keys
6. Run server: `uvicorn src.main:app --reload`
7. Access `http://localhost:8000/docs` for documentation

### Required Environment Variables

```env
OPENAI_API_KEY=sk-your-openai-key-here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_API_KEY=your-azure-key
MODEL_NAME=gpt-3.5-turbo
MAX_TOKENS=1000
TEMPERATURE=0.7
```

## Security Considerations

- Protect API keys with environment variables
- Implement rate limiting for AI endpoints
- Validate and sanitize chat inputs
- Don't log sensitive conversation content
- Use timeouts for AI API requests
- Implement authentication for chat access

## Troubleshooting

### Common AI Issues

**API key error:**
- Verify OPENAI_API_KEY is configured
- Validate the key has correct permissions

**OpenAI rate limiting:**
- Implement exponential backoff
- Use rate limiting in service

**Slow responses:**
- Adjust request timeout
- Use faster models for development
- Implement streaming for long responses

**Context errors:**
- Verify model token limits
- Implement chat history truncation

## PR Instructions

- Run all tests including AI mocks
- Verify no real API keys are committed
- Include tests for new chat functionality
- Document changes in models or prompts
- Update example environment variables

## State Management

### Conversation State
- Implement chat memory with Redis or database
- Use session IDs for conversation tracking
- Consider TTL for cleaning old conversations

### Model State
- Cache common responses
- Manage conversation context
- Store user preferences

## Templates and Workflows

### CI/CD Workflows for AI

The project includes specific workflows for:

- Tests with AI API mocks
- Prompt and response validation
- Deployment with API key secrets
- API cost monitoring

### Prompt Templates

- Keep prompts in separate files
- Use templates for dynamic prompts
- Version prompt changes
- Implement A/B testing for prompts

### LangChain Integration

```python
# Integration example
from langchain.llms import OpenAI
from langchain.chains import ConversationChain

llm = OpenAI(temperature=0.7)
conversation = ConversationChain(llm=llm)
```
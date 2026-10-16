---
name: markitdown
description: Convert local PDF, Word, Excel, PowerPoint, HTML, CSV and other documents into Markdown for extraction and analysis using Microsoft's MarkItDown.
---

# MarkItDown

Use this skill to extract document text and structure into Markdown. For visual layout, scanned pages or image-only content, inspect the original and report extraction limits; ordinary conversion does not guarantee OCR or faithful page layout.

## Run locally

The collection's `install-tools.cmd` installs MarkItDown in `%USERPROFILE%\.local\share\codex-skills\markitdown-venv` on Windows. Prefer its `Scripts\python.exe`; otherwise use an existing Python environment containing `markitdown`.

```powershell
$mdPython = Join-Path $env:USERPROFILE '.local\share\codex-skills\markitdown-venv\Scripts\python.exe'
& $mdPython -m markitdown 'C:\path\input.pdf' -o 'C:\path\output.md'
```

For controlled local conversion from Python:

```python
from markitdown import MarkItDown
result = MarkItDown(enable_plugins=False).convert_local("input.docx")
print(result.text_content)
```

Choose a new output path or preserve existing output before overwriting. Check the exit status and resulting text, tables and headings before using them in analysis. Report missing dependencies and unreadable or empty extraction explicitly.

Keep plugins disabled unless requested. Use `convert_local()` for local files and binary `convert_stream()` for supplied streams. Network URLs, cloud OCR, transcription services and LLM image descriptions require the user's task to authorize those services and any transfer of document content. Follow the session's browser instructions for web browsing.

This is a collection-authored adapter, not an official Microsoft skill. Upstream code and usage: https://github.com/microsoft/markitdown. Original documentation and MIT license are preserved under `sources/markitdown` in the collection checkout.

# Versioning Strategy

## Branch Naming Convention

### Release Branches
- `release/v1.0.0` - For version 1.0.0 release
- `release/v1.1.0` - For version 1.1.0 release
- `release/v2.0.0` - For major version 2.0.0

### Semantic Versioning Tags
- `v1.0.0` - Major.Minor.Patch
- `v1.0.1` - Patch release
- `v1.1.0` - Minor release
- `v2.0.0` - Major release

## Workflow

1. **Development**: Work on feature branches
2. **Release**: Create `release/v1.0.0` branch
3. **Testing**: CI/CD runs on release branch
4. **Tagging**: Create tag `v1.0.0` when ready
5. **Deployment**: Automatic deployment on tag push

## Example Commands

```bash
# Create release branch
git checkout -b release/v1.0.0

# After testing, create tag
git tag v1.0.0
git push origin v1.0.0

# Or use workflow_dispatch with version input
```

## CI/CD Triggers

- **CI Pipeline**: Runs on `release/**` branches and `v*.*.*` tags
- **Deploy Pipeline**: Deploys on `release/**` branches and `v*.*.*` tags


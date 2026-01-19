#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WORKSPACE_DIR="$(dirname "${DIR}")"
CONFIGFILES_DIR="${WORKSPACE_DIR}/configfiles"

# Helper function to resolve absolute path
resolve_abs_path() {
    local path="$1"
    local base_dir="$2"
    if [[ "${path}" == /* ]]; then
        echo "${path}"
    else
        local abs_base=$(cd "${base_dir}" && pwd)
        echo "${abs_base}/${path}"
    fi
}

# Function to move and symlink a directory
move_and_symlink_dir() {
    local source="$1"
    local target_dir="$2"
    local name="$3"
    
    if [ ! -e "${source}" ]; then
        echo "Source does not exist: ${source}, skipping..."
        return
    fi
    
    # If it's already a symlink, check if it points to the right place
    if [ -L "${source}" ]; then
        local link_target=$(readlink "${source}")
        local abs_expected_target=$(cd "${target_dir}" && pwd)/${name}
        local abs_link_target=$(resolve_abs_path "${link_target}" "$(dirname "${source}")")
        # Normalize paths by resolving them - use separate steps to avoid nested substitution issues
        local link_dir=$(dirname "${abs_link_target}")
        local link_base=$(basename "${abs_link_target}")
        if [ -d "${link_dir}" ] 2>/dev/null; then
            abs_link_target=$(cd "${link_dir}" 2>/dev/null && pwd)/${link_base}
        fi
        if [ "${abs_link_target}" = "${abs_expected_target}" ] || [ "${link_target}" = "${target_dir}/${name}" ] || [ "${link_target}" = "${abs_expected_target}" ]; then
            echo "Already symlinked: ${source} -> ${target_dir}/${name}"
            return
        else
            echo "Warning: ${source} is a symlink pointing elsewhere: ${link_target}"
            return
        fi
    fi
    
    # If target directory doesn't exist, create it
    if [ ! -d "${target_dir}" ]; then
        mkdir -p "${target_dir}"
    fi
    
    # Check if target already exists
    if [ -e "${target_dir}/${name}" ]; then
        echo "Target already exists: ${target_dir}/${name}"
        # If source is a regular directory and target exists, create symlink if not already linked
        if [ -d "${source}" ] && [ ! -L "${source}" ]; then
            echo "Warning: Both source and target exist. Source is not a symlink. Manual intervention may be needed."
        elif [ ! -L "${source}" ]; then
            # Target exists but source is not a symlink, create it
            local abs_target=$(cd "${target_dir}" && pwd)/${name}
            echo "Creating symlink: ${source} -> ${abs_target}"
            ln -s "${abs_target}" "${source}"
        fi
        return
    fi
    
    # Move the directory
    if [ -d "${source}" ]; then
        echo "Moving ${source} to ${target_dir}/${name}..."
        mv "${source}" "${target_dir}/${name}"
        # Create symlink with absolute path
        local abs_target=$(cd "${target_dir}" && pwd)/${name}
        ln -s "${abs_target}" "${source}"
        echo "Created symlink: ${source} -> ${abs_target}"
    fi
}

# Function to move and symlink a file
move_and_symlink_file() {
    local source="$1"
    local target_dir="$2"
    local name="$3"
    
    if [ ! -e "${source}" ]; then
        echo "Source does not exist: ${source}, skipping..."
        return
    fi
    
    # If it's already a symlink, check if it points to the right place
    if [ -L "${source}" ]; then
        local link_target=$(readlink "${source}")
        local abs_expected_target=$(cd "${target_dir}" && pwd)/${name}
        local abs_link_target=$(resolve_abs_path "${link_target}" "$(dirname "${source}")")
        # Normalize paths by resolving them - use separate steps to avoid nested substitution issues
        local link_dir=$(dirname "${abs_link_target}")
        local link_base=$(basename "${abs_link_target}")
        if [ -d "${link_dir}" ] 2>/dev/null; then
            abs_link_target=$(cd "${link_dir}" 2>/dev/null && pwd)/${link_base}
        fi
        if [ "${abs_link_target}" = "${abs_expected_target}" ] || [ "${link_target}" = "${target_dir}/${name}" ] || [ "${link_target}" = "${abs_expected_target}" ]; then
            echo "Already symlinked: ${source} -> ${target_dir}/${name}"
            return
        else
            echo "Warning: ${source} is a symlink pointing elsewhere: ${link_target}"
            return
        fi
    fi
    
    # If target directory doesn't exist, create it
    if [ ! -d "${target_dir}" ]; then
        mkdir -p "${target_dir}"
    fi
    
    # Check if target already exists
    if [ -e "${target_dir}/${name}" ]; then
        echo "Target already exists: ${target_dir}/${name}"
        # If source is a regular file and target exists, create symlink if not already linked
        if [ -f "${source}" ] && [ ! -L "${source}" ]; then
            echo "Warning: Both source and target exist. Source is not a symlink. Manual intervention may be needed."
        elif [ ! -L "${source}" ]; then
            # Target exists but source is not a symlink, create it
            local abs_target=$(cd "${target_dir}" && pwd)/${name}
            echo "Creating symlink: ${source} -> ${abs_target}"
            ln -s "${abs_target}" "${source}"
        fi
        return
    fi
    
    # Move the file
    if [ -f "${source}" ]; then
        echo "Moving ${source} to ${target_dir}/${name}..."
        mv "${source}" "${target_dir}/${name}"
        # Create symlink with absolute path
        local abs_target=$(cd "${target_dir}" && pwd)/${name}
        ln -s "${abs_target}" "${source}"
        echo "Created symlink: ${source} -> ${abs_target}"
    fi
}

# Setup claude-code-router config (remove dot from git name)
# NOTE: Excluded - keeping in ~/ instead of configfiles/
# move_and_symlink_dir "${HOME}/.claude-code-router" "${CONFIGFILES_DIR}" "claude-code-router"

# Setup claude config directory (remove dot from git name)
# NOTE: Excluded - keeping in ~/ instead of configfiles/
# move_and_symlink_dir "${HOME}/.claude" "${CONFIGFILES_DIR}" "claude"

# Setup claude json files (keep names as-is, no leading dot)
# NOTE: These are excluded - keeping them in ~/ instead of configfiles/
# move_and_symlink_file "${HOME}/.claude.json" "${CONFIGFILES_DIR}" "claude.json"
# move_and_symlink_file "${HOME}/.claude.json.backup" "${CONFIGFILES_DIR}" "claude.json.backup"

# Setup gemini config (remove dot from git name)
# NOTE: Excluded - keeping in ~/ instead of configfiles/
# move_and_symlink_dir "${HOME}/.gemini" "${CONFIGFILES_DIR}" "gemini"

# Setup cursor config (remove dot from git name)
# NOTE: Excluded - keeping in ~/ instead of configfiles/
# move_and_symlink_dir "${HOME}/.cursor" "${CONFIGFILES_DIR}" "cursor"

echo "AI config setup complete!"

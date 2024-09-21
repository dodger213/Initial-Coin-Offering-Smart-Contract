// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Context.sol";

abstract contract Whitelist is Context {
    /**
     * @dev Emitted when the whitelist is triggered by `account`.
     */
    event EnableWhitelist(address account);

    /**
     * @dev Emitted when the whitelist is lifted by `account`.
     */
    event DisableWhitelist(address account);

    bool private _whitelist;

    /**
     * @dev Initializes the contract in a disabled whitelist state.
     */
    constructor() {
        _whitelist = false;
    }

    /**
     * @dev Returns true if whitelist is enabled, and false otherwise.
     */
    function whitelist() public view virtual returns (bool) {
        return _whitelist;
    }

    /**
     * @dev Modifier to make a function callable only when whitelist is disabled.
     *
     * Requirements:
     *
     * - The whitelist must be disabled.
     */

    modifier whenDisabledWhitelist() {
        require(!whitelist(), "Whitelist is not disabled");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when whitelist is enabled.
     *
     * Requirements:
     *
     * - The whitelist must be enabled.
     */
    modifier whenEnabledWhitelist() {
        require(whitelist(), "Whitelist is not enabled");
        _;
    }

    /**
     * @dev Triggers enable state.
     *
     * Requirements:
     *
     * - The whitelist must be disabled.
     */
    function _enableWhitelist() internal virtual whenDisabledWhitelist {
        _whitelist = true;
        emit EnableWhitelist(_msgSender());
    }

    /**
     * @dev Triggers disable state.
     *
     * Requirements:
     *
     * - The whitelist must be enabled.
     */
    function _disableWhitelist() internal virtual whenEnabledWhitelist {
        _whitelist = false;
        emit DisableWhitelist(_msgSender());
    }
}

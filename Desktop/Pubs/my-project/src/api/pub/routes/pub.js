'use strict';

module.exports = {
    routes: [
                {
      method: 'GET',
      path: '/pubs',
      handler: 'pub.find',
      config: {}
    },
        {
      method: 'GET',
      path: '/pubs/affordable',
      handler: 'pub.getAffordablePubs',
      config: { auth: false },
    },
]

};
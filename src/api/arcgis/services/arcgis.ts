/**
 * arcgis service
 */

import {factories} from '@strapi/strapi';
import fetch from 'node-fetch';
import qs from 'qs';

export default factories.createCoreService('api::arcgis.arcgis', ({ strapi }) => ({
  auth: async ({ referer }: { referer: string }) => {
    const { url, auth: { username, password } } = strapi.config.arcgis
    const response = await fetch(
      `${url}/portal/sharing/rest/generateToken`,
      {
        method: 'POST',
        body: qs.stringify({
          f: 'json',
          username,
          password,
          client: 'referer',
          referer,
          expiration: 60
        }),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          Accept: 'application/json'
        }
      }
    )
    return await response.json() as ArcGisToken
  }
}));
